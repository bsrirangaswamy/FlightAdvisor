//
//  Airline.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import ObjectMapper

class Airline: Mappable {
    var name: String?
    var twoDigitCode: String?
    var threeDigitCode: String?
    var country: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        name                <- map["Name"]
        twoDigitCode        <- map["2 Digit Code"]
        threeDigitCode      <- map["3 Digit Code"]
        country             <- map["Country"]
    }
}
