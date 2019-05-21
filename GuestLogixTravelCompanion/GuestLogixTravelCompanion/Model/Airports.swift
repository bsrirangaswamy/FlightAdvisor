//
//  Airports.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import ObjectMapper

class Airports: Mappable {
    var name: String?
    var city: String?
    var country: String?
    var iata3: String?
    var latitude: Double?
    var longitude: Double?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        name        <- map["Name"]
        city        <- map["City"]
        country     <- map["Country"]
        iata3       <- map["IATA 3"]
        latitude    <- map["Latitute"]
        longitude   <- map["Longitude"]
    }
}
