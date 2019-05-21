//
//  GuestLogixTravelCompanionTests.swift
//  GuestLogixTravelCompanionTests
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import GuestLogixTravelCompanion

class GuestLogixTravelCompanionTests: XCTestCase {
    
    var vcTest: ViewController!

    override func setUp() {
        super.setUp()
        vcTest = ViewController()
    }

    override func tearDown() {
        vcTest = nil
        super.tearDown()
    }
    
    func testAirportMapper() {
        // 1. Given
        let jsonDict: [String: Any] = ["Name": "GuestLogix", "City": "Toronto", "Country": "Canada", "IATA 3": "YYZ", "Latitute": 43.67720032, "Longitude": -79.63059998]
        
        // 2. When
        let testAirport = Mapper<Airports>().map(JSON: jsonDict)
        
        // 3. Then
        XCTAssertEqual(testAirport?.name, "GuestLogix", "Airport name mapped incorrectly")
        XCTAssertEqual(testAirport?.iata3, "YYZ", "Airport iata3 mapped incorrectly")
        XCTAssertEqual(testAirport?.longitude, -79.63059998, "Airport longitude mapped incorrectly")
    }
    
    func testRoutesMapper() {
        let jsonDict: [String: Any] = ["Airline Id": "AC", "Origin": "ANU", "Destination": "YYZ"]
        
        let testRoute = Mapper<Routes>().map(JSON: jsonDict)
        
        XCTAssertEqual(testRoute?.airlineID, "AC", "Route airline ID mapped incorrectly")
        XCTAssertEqual(testRoute?.origin, "ANU", "route origin mapped incorrectly")
        XCTAssertEqual(testRoute?.destination, "YYZ", "route destination mapped incorrectly")
    }
    
    func testAirlineMapper() {
        let jsonDict: [String: Any] = ["Name": "WestJet", "2 Digit Code": "WS", "3 Digit Code": "WJA", "Country": "Canada",]
        
        let testAirline = Mapper<Airline>().map(JSON: jsonDict)
        
        XCTAssertEqual(testAirline?.name, "WestJet", "Airline Name mapped incorrectly")
        XCTAssertEqual(testAirline?.twoDigitCode, "WS", "Airline twoDigitCode mapped incorrectly")
        XCTAssertEqual(testAirline?.threeDigitCode, "WJA", "Airline threeDigitCode mapped incorrectly")
    }
    
    func testDistanceCalculation() {
        let oLatitude = 37.61899948
        let oLongitude = -122.375
        let dLatitude = 43.67720032
        let dLongitude = -79.63059998
        
        let distance = vcTest.getDistanceFrom(oLatitude: oLatitude, oLongitude: oLongitude, dLatitude: dLatitude, dLongitude: dLongitude)
        
        XCTAssertEqual(distance, 2259, "Distance calcutaion incorrect")
    }

}
