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
   // let  point = MKPointAnnotation()
    //var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    var lat: Double?
    @IBOutlet weak var mapView: MKMapView!
    //ref = Database.database().reference()
    lazy var ref: DatabaseReference = Database.database().reference()
    var postRef: DatabaseReference!
    
    
    

    let locationManager = CLLocationManager()
    var currentCorrdinate : CLLocationCoordinate2D!
  
    let allFriendUid = ["8yrC5blg1gUmZjOzf9wyzcZ2GV03","IEWbcPgBVmR9QYDpjUQjaGLDsqB3"]
   var showSpotsArray = [ShowSpots]()
   var finalSpotsArray = [FinalSpot]()
    
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
      
      
        for index in allFriendUid {
            FriendLocation.friendLocation(uid: index) { (result:[Travel]) in
                
                for results in result{
                      print("results",results)
                    let coordinate = CLLocationCoordinate2D(latitude: (results.location.last?.lat)!, longitude: (results.location.last?.long)!)
                    let showspots = ShowSpots(title: results.uid, subtitle: results.userName, coordinate: coordinate)
                  var  point = MKPointAnnotation()
                  point.coordinate = showspots.coordinate
                  point.title = showspots.title
                     self.mapView.addAnnotation(point)
                }
            
                //self.mapView.removeAnnotation(self.point)
            }
        }
    }

        
    
        

    
    
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
            ref.child("location").child("8yrC5blg1gUmZjOzf9wyzcZ2GV03").child(id).setValue(post)
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
   //   postLocation(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
       //25.043730, 121.565545 松山高中
        //25.042468, 121.564160 真芳
        // 25.043152, 121.563745 富式
        //25.042231, 121.564855 正旅館
        //25.043500, 121.567451 全聯
 //postLocation(lat:25.043500, long:121.567451)//
        
//       let location = locations[0]
//   //  guard let location = locations.first else { return }
//        print(location)
//
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//          print("user latitude = \(location.coordinate.latitude)")
//               print("user longitude = \(location.coordinate.longitude)")
//        self.mapView.setRegion(region, animated: true)
//

      

       

        
//        let location = locations[0]
//
//        let center = location.coordinate
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: center, span: span)
//
//        mapView.setRegion(region, animated: true)
//        mapView.showsUserLocation = true
//
//        //https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//        let userLocation :CLLocation = locations[0] as CLLocation
//
//        lat = userLocation.coordinate.latitude as? Double
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
    
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
















