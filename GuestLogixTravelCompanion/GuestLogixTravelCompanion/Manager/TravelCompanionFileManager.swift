//
//  TravelCompanionFileManager.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class TravelCompanionFileManager: NSObject {
    
    static let sharedInstance = TravelCompanionFileManager()
    
    func getJson(fileName: String) {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonArray = json as? [Any] {
                    // json is an array
//                    print("Bala is an array = \(jsonArray)")
                    mapToModel(filename: fileName, jsonArray: jsonArray)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("File doesnot exist")
            }
        } catch {
            print("Bala JSON fetch error = \(error.localizedDescription)")
        }
    }
    
    private func mapToModel(filename: String, jsonArray: [Any]) {
        guard let jArray = jsonArray as? [[String : Any]] else { return }
        if filename == "airline" {
            TravelComapanionDataManager.sharedInstance.airlinesArray = Mapper<Airline>().mapArray(JSONArray: jArray)
        } else if filename == "airports" {
            let airportsArray = Mapper<Airports>().mapArray(JSONArray: jArray).filter({ $0.iata3 != nil && $0.iata3 != "" })
            TravelComapanionDataManager.sharedInstance.airportsDictionary = Dictionary(grouping: airportsArray, by: { $0.iata3! })
        } else if filename == "routes" {
            TravelComapanionDataManager.sharedInstance.routesArray = Mapper<Routes>().mapArray(JSONArray: jArray)
        }
    }

}
