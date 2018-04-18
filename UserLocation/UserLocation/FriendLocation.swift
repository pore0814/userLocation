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
//    static var locationArray = [Location]()
//    static var travel: Travel?
    
    static func friendLocation(uid: String , data: @escaping (Travel) ->() ){
         var location: Location?
           var travel: Travel?
        Database.database().reference().child("location").child(uid).observe(.childAdded, with: { (snapshot) in
        print("------snapshot.vale------")
            print(uid)
            print(snapshot.value)
            if let locationContent = snapshot.value as? [String: Double]{
                let lat = locationContent["latitude"] as! Double
                let lng = locationContent["longitude"] as! Double
                location = Location(lat: lat, long: lng)
            
            }
            
             travel = Travel(uid: uid, userName: "Annie", location: location!)
            data(travel!)
      })
     
    
    }
    
}



