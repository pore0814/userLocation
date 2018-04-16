//
//  FriendLocation.swift
//  UserLocation
//
//  Created by 王安妮 on 2018/4/15.
//  Copyright © 2018年 Yash Patel. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FriendLocation {
    static var locationArray = [Location]()
    static var travelArray = [Travel]()
    
    static func friendLocation(uid: String , data: @escaping ([Travel]) ->() ){
        
        Database.database().reference().child("location").child(uid).observe(.value, with: { (snapshot) in
         //   print(snapshot.value)
            
            //  拿單一筆資料
            if  let locationDict = snapshot.value as? [String: Any] {
             //print("locationDict",locationDict)
                for location in locationDict {
            
                    let location = location.value as! [String:Double]
                    let lat  = location["latitude"] as! Double
                    let lng  = location["longitude"] as! Double
                    let locationInstance = Location(lat:lat ,long: lng)
                    
                   //locationA
                    self.locationArray.append(locationInstance)
                }
            }
            let travel = Travel(uid: uid, userName: "pore0814", location: self.locationArray)
            //print("travel",travel)
            self.travelArray.append(travel)
           print("travelArray",self.travelArray)
            //print("count",self.travelArray.count)

            data(self.travelArray)
      })
        for i in travelArray {
            print("i",i.uid)
        }
        
    }
}



