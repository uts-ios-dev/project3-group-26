//
//  MapControl.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 27/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import AVFoundation

class MapControl: NSObject, CLLocationManagerDelegate {
    
    let placeSearchKey = "AIzaSyCXjncpMkQAeoNQRGgDYjoWjLI5MOT7aoI"
    
    // location manager to get location
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentHeading: CLHeading!
    var placesClient: GMSPlacesClient!
    var nearbyPlaces: [NearbyPlace] = []
    var frontPlaces: [NearbyPlace] = []
    var rightPlaces: [NearbyPlace] = []
    var backPlaces: [NearbyPlace] = []
    var leftPlaces: [NearbyPlace] = []
    var numUpdate = 0
    
    var autoSpeaking = true
    var enable = false
    
    func start() {
        
    }
    
    func activate() {
        enable = true
    }
    
    func inactivate() {
        enable = false
    }
    
    func getFrontPlaces() -> [NearbyPlace] {
        return frontPlaces
    }
    
    func getRightPlaces() -> [NearbyPlace] {
        return rightPlaces
    }
    
    func getBackPlaces() -> [NearbyPlace] {
        return backPlaces
    }
    
    func getLeftPlaces() -> [NearbyPlace] {
        return leftPlaces
    }
    
    func isAutoSpeaking() -> Bool {
        return autoSpeaking
    }
    
    func toggleAutoSpeaking() {
        autoSpeaking = !autoSpeaking
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
}
