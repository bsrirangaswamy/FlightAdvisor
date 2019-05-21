//
//  ViewController.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/16/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var searchRoutesButton: UIButton!
    @IBOutlet weak var routesTableView: UITableView!
    
    var originString: String?
    var destinationString: String?
    var flightRoutesArray: [[Routes]]?
    var mapRoute: [Routes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originTextField.delegate = self
        destinationTextField.delegate = self
        routesTableView.isHidden = true
        
        // Map all JSON data into our objects
        TravelCompanionFileManager.sharedInstance.getJson(fileName: "airline")
        TravelCompanionFileManager.sharedInstance.getJson(fileName: "airports")
        TravelCompanionFileManager.sharedInstance.getJson(fileName: "routes")
        
        // Map Airport to respective Route
        TravelComapanionDataManager.sharedInstance.mapAirportsToRoutes()
        
        //Set Navigation Bar Title
        self.title = "kFlightAdvisor".localized
    }
    
    @IBAction func searchRoutesButtonPressed(_ sender: UIButton) {
        guard let oStr = originString, oStr.count > 0 , let dStr = destinationString, dStr.count > 0, let airportsDict = TravelComapanionDataManager.sharedInstance.airportsDictionary else {
            addAlert(title: "", message: "kDataUnavailable".localized)
            return
        }
        guard let _ = airportsDict[oStr] else {
            addAlert(title: "kAirportUnavailable".localized, message: "kOriginAirportDoesnotExist".localized)
            return
        }
        guard let _ = airportsDict[dStr] else {
            addAlert(title: "kAirportUnavailable".localized, message: "kDestinationAirportDoesnotExist".localized)
            return
        }
        
        if let directArray = findAllPossibleDirectRoutes(originStr: oStr, destStr: dStr), !directArray.isEmpty {
            flightRoutesArray = directArray
            routesTableView.isHidden = false
            print("No direct flights")
        } else if let oneStopArray = findAllOneStopRoutes(originStr: oStr, destStr: dStr), !oneStopArray.isEmpty {
            let sortedOneStopArray = oneStopArray.sorted(by: {
                return getTotalDistance(routes: $0) < getTotalDistance(routes: $1)
            })
            flightRoutesArray = sortedOneStopArray
            routesTableView.isHidden = false
            print("No one stop flights")
        } else if let twoStopArray = findAllTwoStopRoutes(originStr: oStr, destStr: dStr), !twoStopArray.isEmpty {
            let sortedtwoStopArray = twoStopArray.sorted(by: {
                return getTotalDistance(routes: $0) < getTotalDistance(routes: $1)
            })
            flightRoutesArray = sortedtwoStopArray
            routesTableView.isHidden = false
            print("No two stop flights")
        } else {
            flightRoutesArray = nil
            routesTableView.isHidden = true
            addAlert(title: "kNoFlights".localized, message: "kNoFlightsAvailableRoute".localized)
            print("No flights")
        }
        routesTableView.reloadData()
    }
    
    func findAllPossibleDirectRoutes(originStr: String, destStr: String) -> [[Routes]]? {
        guard let routesArray = TravelComapanionDataManager.sharedInstance.routesArray else { return nil }
        let directRoutesArray = routesArray.filter { $0.origin == originString && $0.destination == destStr }
        var nsArray = [[Routes]]()
        for route in directRoutesArray {
            nsArray.append([route])
        }
        return nsArray
    }
    
    func findAllOneStopRoutes(originStr: String, destStr: String) -> [[Routes]]? {
        guard let routesArray = TravelComapanionDataManager.sharedInstance.routesArray else { return nil }
        
        let matchingOriginArray = routesArray.filter { $0.origin == originStr }
        let matchingDestinationArray = routesArray.filter { $0.destination == destStr }
        
        var osRoutesArray = [[Routes]]()
        for routeA in matchingOriginArray {
            if let routeB = matchingDestinationArray.first(where: { $0.origin == routeA.destination }) {
                let routeMap = [routeA, routeB]
                osRoutesArray.append(routeMap)
            }
        }
        return osRoutesArray
    }
    
    func findAllTwoStopRoutes(originStr: String, destStr: String) -> [[Routes]]? {
        guard let routesArray = TravelComapanionDataManager.sharedInstance.routesArray else { return nil }

        let matchingOriginArray = routesArray.filter { $0.origin == originStr }
        let matchingDestinationArray = routesArray.filter { $0.destination == destStr }

        var tempArrayAB = [[Routes]]()
        var tempArrayCD = [[Routes]]()
        for a in matchingOriginArray {
            if let b = routesArray.first(where: { $0.origin == a.destination }) {
                let routeMap = [a, b]
                tempArrayAB.append(routeMap)
            }
        }
        
        for d in matchingDestinationArray {
            if let c = routesArray.first(where: { $0.destination == d.origin }) {
                let routeMap = [c, d]
                tempArrayCD.append(routeMap)
            }
        }
        
        guard tempArrayAB.count > 0 && tempArrayCD.count > 0 else { return nil }
        
        var finalRouteMapArray = [[Routes]]()
        for routeArrayAB in tempArrayAB {
            if let routeArrayCD = tempArrayCD.first(where: { $0[0].origin == routeArrayAB[1].destination }) {
                finalRouteMapArray.append(routeArrayAB + routeArrayCD)
            }
        }
        return finalRouteMapArray
    }
    
    func getTotalDistance(routes: [Routes]) -> Int {
        var totalDistance = 0
        for route in routes {
            totalDistance = totalDistance + getDistance(route: route)
        }
        return totalDistance
    }
    
    func getDistance(route: Routes) -> Int {
        var distance = 0
        guard let originAirport = route.originAirport, let destinationAirport = route.destinationAirport else { return distance }
        guard let oLatitude = originAirport.latitude, let oLongitude = originAirport.longitude, let dLatitude = destinationAirport.latitude, let dLongitude = destinationAirport.longitude else { return distance }
        distance = getDistanceFrom(oLatitude: oLatitude, oLongitude: oLongitude, dLatitude: dLatitude, dLongitude: dLongitude)
        return distance
    }
    
    func getDistanceFrom(oLatitude: Double, oLongitude: Double, dLatitude: Double, dLongitude: Double) -> Int {
        let c0 = CLLocation(latitude: oLatitude, longitude: oLongitude)
        let c1 = CLLocation(latitude: dLatitude, longitude: dLongitude)
        return Int(c0.distance(from: c1) / 1609)
    }
    
    func addAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let originValue = originTextField.text {
            originString = originValue
        }
        
        if let destinationValue = destinationTextField.text {
            destinationString = destinationValue
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let inputText = textField.text, let stringRange = Range(range, in: inputText) else { return false }
        
        let updatedText = inputText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 3
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if let frArray = flightRoutesArray, frArray.count > 0 {
            rowCount = frArray.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routesCell = tableView.dequeueReusableCell(withIdentifier: "routesDisplay", for: indexPath) as! RoutesDisplayTableViewCell
        
        if let frArray = flightRoutesArray, frArray.count > 0  {
            let (pathString, airlineString, stopInfoString, distanceDouble) = showRoutePath(routeArray: frArray[indexPath.row])
            routesCell.routeLabel.text = pathString
            routesCell.airlinesLabel.text = airlineString
            routesCell.numberOfStopsLabel.text = stopInfoString
            routesCell.distanceLabel.text = "kTotalDistance".localized + "\(distanceDouble) miles"
        }
        
        return routesCell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        mapRoute = flightRoutesArray?[indexPath.row]
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapRoute = flightRoutesArray?[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showRoutePath(routeArray: [Routes]) -> (String, String, String, Int) {
        var pathString = ""
        var airlinesString = ""
        var stopInfoString = ""
        var distanceInt = 0
        for route in routeArray {
            pathString = pathString + " => " + "\(route.origin!)" + " -> " + "\(route.destination!)"
            airlinesString = airlinesString + " => " + "\(route.airlineID!)"
            distanceInt = distanceInt + getDistance(route: route)
        }
        if routeArray.count == 1 {
            stopInfoString = "kNonStopFlights".localized
        } else if routeArray.count == 2 {
            stopInfoString = "kOneStopFlights".localized
        } else {
            stopInfoString = "kTwoStopFlights".localized
        }
        return (pathString, airlinesString, stopInfoString, distanceInt)
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapSegue", let routeMapController = segue.destination as? RouteMapViewController {
            routeMapController.routes = mapRoute
            print("Bala sent appropriate route to map")
        }
    }
}

extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

