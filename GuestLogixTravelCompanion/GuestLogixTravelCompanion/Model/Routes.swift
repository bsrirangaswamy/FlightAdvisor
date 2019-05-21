//
//  Routes.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import ObjectMapper

class Routes: Mappable {
    var airlineID: String?
    var origin: String?
    var destination: String?
    var originAirport: Airports?
    var destinationAirport: Airports?

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        airlineID       <- map["Airline Id"]
        origin          <- map["Origin"]
        destination     <- map["Destination"]
    }
}
