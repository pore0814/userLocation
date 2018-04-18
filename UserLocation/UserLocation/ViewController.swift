//
//  ViewController.swift
//  UserLocation
//
//  Created by Yash Patel on 06/12/17.
//  Copyright © 2017 Yash Patel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
class ViewController: UIViewController, CLLocationManagerDelegate {
  
    let userID = Auth.auth().currentUser?.uid

    @IBOutlet weak var mapView: MKMapView!
    //ref = Database.database().reference()
    lazy var ref: DatabaseReference = Database.database().reference()
    var postRef: DatabaseReference!
    
    

    let locationManager = CLLocationManager()
    var currentCorrdinate : CLLocationCoordinate2D!
    var allFriendInfo = [UserInfo(uid: "8yrC5blg1gUmZjOzf9wyzcZ2GV03", name: "pore0814", image: ""),UserInfo(uid: "IEWbcPgBVmR9QYDpjUQjaGLDsqB3", name: "pore", image: "")]

  
   var friendSpotsArray = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
       
        getdata()
        }
    
        
   
    func getdata(){
      
        
        for index in allFriendInfo{

            FriendLocation.friendLocation(uid: index.uid) { (results:Travel) in
       
                 //__________開始判斷-----------//地圖上重覆的marker抓出來-> //顯示在地圖上
                if self.friendSpotsArray.count <= 0 {
                    self.firstMarker(results: results, userid: index.uid , username: index.name)
                }
                else
                    {
                    for i in 0...self.friendSpotsArray.count  - 1 {
                        if results.uid == self.friendSpotsArray[i].id{
                            //remove annotation
                            self.mapView.removeAnnotation(self.friendSpotsArray[i].annation)
                            //remove Array
                            self.friendSpotsArray.remove(at: i)
                            //取得使用者最後一筆經緯度
                            let coordinate = CLLocationCoordinate2D(latitude: results.location.lat!, longitude: results.location.long!)
                            //轉成Marker
                            let showspots = ShowSpots(title: results.uid, subtitle: String(results.location.lat!), coordinate: coordinate)
                            var myfriend = Friend(annation: showspots, id:index.uid, name: index.name)
                            //顯示到map上
                            self.mapView.addAnnotation(myfriend.annation)
                            //新增到Array裡
                            self.friendSpotsArray.append(myfriend)
                            return
                        }
                    }
                    self.firstMarker(results:results,userid: index.uid,username: index.name )
                }
            }
        }
    }

    
    func firstMarker(results:Travel, userid: String , username: String){
        //取得使用者最後一筆經緯度
        let coordinate = CLLocationCoordinate2D(latitude: results.location.lat!, longitude: results.location.long!)
        //轉成Marker
        let showspots = ShowSpots(title: results.uid, subtitle: String(results.location.lat!), coordinate: coordinate)
        //生成Friend物件
        var myfriend = Friend(annation: showspots, id:userid, name: username)
        //加到friendArray裡
        self.friendSpotsArray.append(myfriend)
        //顯示在map上
        self.mapView.addAnnotation(myfriend.annation)
        
    }
    
    
    
    
    

    /*
    func getDirctions(to destination: MKPlacemark) {
        let sourcePlacemark = MKPlacemark(coordinate: currentCorrdinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = MKMapItem(placemark: destination)
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            guard let response = response  else {return}
            guard let primaryRoute = response.routes.first else {return}
            self.mapView.add(primaryRoute.polyline,level: .aboveRoads)
            
            let rect = primaryRoute.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
     }
 
     }
    */
    //傳經緯度到資料庫
    func postLocation(lat:Double, long:Double){
        let id = self.ref.child("location").childByAutoId().key
      // let created_time = Int(Date().timeIntervalSince1970 * 1000)
      //  let userLocation =  Location(lat1: lat, long1: long) {
            let post =
                [
                    "latitude": lat,
                    "longitude":long] as [String : Any]
        //  ref?.child("location").child(id!).setValue(post)
        
      //ref.child("location").child(self.userID!).child(id).setValue(post)
            ref.child("location").child("IEWbcPgBVmR9QYDpjUQjaGLDsqB3").child(id).setValue(post)
        }



    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // manager.stopUpdatingLocation()
        

        guard let currentLocation = locations.last else  {return}
        currentCorrdinate = currentLocation.coordinate
        mapView.userTrackingMode = .followWithHeading
        
        
        

/*
        print("user latitude = \(currentLocation.coordinate.latitude)")
        print("user longitude = \(currentLocation.coordinate.longitude)")
 */
  // postLocation(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
       //25.043730, 121.565545 松山高中
        //25.042468, 121.564160 真芳
        // 25.043152, 121.563745 富式
        //25.042231, 121.564855 正旅館
        //25.043500, 121.567451 全聯
 //postLocation(lat:25.042468, long:564160)//
   
//        //https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
    }
}




extension ViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 4.0
        return render
    }
}
















