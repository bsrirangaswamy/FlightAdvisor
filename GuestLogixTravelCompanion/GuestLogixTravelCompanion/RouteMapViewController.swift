//
//  RouteMapViewController.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/18/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import MapKit

class RouteMapViewController: UIViewController {

    @IBOutlet weak var routeMapView: MKMapView!
    var routes: [Routes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeMapView.delegate = self
        self.title = "kRouteMap".localized
        
        if let routesArray = routes {
            let airportAnnotationArray = convertRoutesToAnnotationArray(routes: routesArray)
            if airportAnnotationArray.count > 0 {
                routeMapView.showAnnotations(airportAnnotationArray, animated: true)
                showRouteOnMap(routesAnnotationsArray: airportAnnotationArray)
            }
        }
    }
    
    func convertRoutesToAnnotationArray(routes: [Routes]) -> [RoutesAnnotation] {
        var routeAnnotationArray = [RoutesAnnotation]()
        for route in routes {
            if let originAirport = route.originAirport, let destinationAirport = route.destinationAirport {
                let oiginRouteAnnotation = RoutesAnnotation(title: originAirport.name!, subtitle: originAirport.city!, coordinate: CLLocationCoordinate2D(latitude: originAirport.latitude!, longitude: originAirport.longitude!))
                let destinationRouteAnnotation = RoutesAnnotation(title: destinationAirport.name!, subtitle: destinationAirport.city!, coordinate: CLLocationCoordinate2D(latitude: destinationAirport.latitude!, longitude: destinationAirport.longitude!))
                routeAnnotationArray.append(oiginRouteAnnotation)
                routeAnnotationArray.append(destinationRouteAnnotation)
            }
        }
        return routeAnnotationArray
    }

}

extension RouteMapViewController: MKMapViewDelegate {
    func showRouteOnMap(routesAnnotationsArray: [RoutesAnnotation]) {
        var coordinatePointsArray = [CLLocationCoordinate2D]()
        for routesAnno in routesAnnotationsArray {
            coordinatePointsArray.append(routesAnno.coordinate)
        }
        let polyline = MKPolyline(coordinates: coordinatePointsArray, count: coordinatePointsArray.count)
        routeMapView.addOverlay(polyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}
