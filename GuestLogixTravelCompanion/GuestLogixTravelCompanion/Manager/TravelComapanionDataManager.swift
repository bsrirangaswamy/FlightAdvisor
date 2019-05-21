//
//  TravelComapanionDataManager.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit

class TravelComapanionDataManager: NSObject {
    static let sharedInstance = TravelComapanionDataManager()
    var airlinesArray: [Airline]?
    var airportsDictionary: Dictionary<String, [Airports]>?
    var routesArray: [Routes]?
    
    func mapAirportsToRoutes() {
        guard routesArray != nil && !routesArray!.isEmpty else { return }
        for route in routesArray! {
            if let airportDict = airportsDictionary {
                route.originAirport = airportDict[route.origin!]?[0]
                route.destinationAirport = airportDict[route.destination!]?[0]
            }
        }
    }
}

