//
//  Location.swift
//  UserLocation
//
//  Created by 王安妮 on 2018/4/13.
//  Copyright © 2018年 Yash Patel. All rights reserved.
//

import Foundation
import MapKit

struct Location{
    var lat: Double?
    var long: Double?
    
}


struct Travel {
    var uid : String
    var userName: String
    var location : Location
}

struct FinalSpot {
    var title: String
    var lat: Double?
    var lng: Double?
}


class ShowSpots : NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String,subtitle:String,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

struct Friend {
    var annation: MKAnnotation
    let id : String
    let name : String
}

struct UserInfo {
    
    var uid: String
    var name: String
    var image: String
    
}
