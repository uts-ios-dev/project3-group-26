//
//  SpotNavigation.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 3/6/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation

import MapKit
import CoreLocation
import CoreLocation
import AVFoundation

class Navigation {
    //    let startLocation: CLLocationCoordinate2D
    //    let destinationLocation: CLLocationCoordinate2D
    //
    //    init(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
    //        self.startLocation = startCoordinate
    //        self.destinationLocation = destinationCoordinate
    //    }
    var locationManager = CLLocationManager()
    var steps = [MKRouteStep]()
    var stepCounter = 0
    
    func startNagation(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = startMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let response = response else {
                print("no response")
                return
            }
            
            guard let primaryRoute = response.routes.first else {
                print("get primary route error")
                return
            }
            self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
            self.steps = primaryRoute.steps
            for i in 0 ..< primaryRoute.steps.count {
                let step = primaryRoute.steps[i]
                print(step)
                print(step.polyline.coordinate)
                print(step.instructions)
                print(step.distance)
                // set region at each step, when user get in the region, promoting
                let region = CLCircularRegion(center: step.polyline.coordinate,
                                              radius: 20,
                                              identifier: "\(i)")
                self.locationManager.startMonitoring(for: region)
                //                let circle = MKCircle(center: region.center, radius: region.radius)
            }
            
            // all the instructions
            let initialMessage = "In \(self.steps[0].distance) meters, \(self.steps[0].instructions) then in \(self.steps[1].distance) meters, \(self.steps[1].instructions)."
            print(initialMessage)
            self.stepCounter += 1
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED")
        stepCounter += 1
        if stepCounter < steps.count {
            let currentStep = steps[stepCounter]
            let message = "In \(currentStep.distance) meters, \(currentStep.instructions)"
            print(message)
        } else {
            let message = "Arrived at destination"
            print(message)
            stepCounter = 0
            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
        }
    }
    
}

