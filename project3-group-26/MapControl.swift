//
//  MapControl.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 28/5/18.
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
    var currentAddress: String!
    var currentHeading: CLHeading!
    var placesClient: GMSPlacesClient!
    var nearbyPlaces: [NearbyPlace] = []
    var frontPlaces: [NearbyPlace] = []
    var rightPlaces: [NearbyPlace] = []
    var backPlaces: [NearbyPlace] = []
    var leftPlaces: [NearbyPlace] = []
    var numUpdate = 0
    
    let speak = speechUtil
    var canSpeak = true
    var autoSpeaking = true
    var enable = false
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        // the accuracy of the location, set it the best
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //         set distance and heading filter, decrease the frequence of the update
        self.locationManager.distanceFilter = 10
        self.locationManager.headingFilter = 22.5
        locationManager.requestWhenInUseAuthorization()
        //        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func activate() {
        enable = true
        if enable {
            // start update loation, call the func locationManager
            locationManager.startUpdatingLocation()
            // start update course
            locationManager.startUpdatingHeading()
        }
    }
    
    func inactivate() {
        enable = false
        if !enable {
            locationManager.stopUpdatingLocation()
            speak.stopSpeech()
        }
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
        let testLocation = CLLocation(latitude: -33.8841070, longitude: 151.2003266)
        return testLocation
        //        return currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("num of update: \(numUpdate)")
        numUpdate += 1
        
        // the most recent location update is at the end of the array, and the accurancy is most best
        let location = locations[locations.count - 1]
        print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        currentLocation = location
        convetToAddress(location: currentLocation!)
        
        if currentLocation == nil {
            return
        }
        let searchLocation: String = "\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)"
        print(searchLocation)
        let searchParams: [String: String] = ["location": searchLocation, "radius": "50", "key": placeSearchKey]
        
        // get nearby places, save in array,
        fetchLocationInfo(parameters: searchParams)
        // stop a while
        sleep(2)
    }
    
    // convert location coordinate to a address
    func convetToAddress(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("error")
            } else {
                // print the address: number, street, city, postcode
                if let place = placemark?[(placemark?.count)! - 1] {
                    if let _ = place.subThoroughfare {
                        self.currentAddress = "\(place.subThoroughfare!), \(place.thoroughfare!), \(place.locality!), \(place.postalCode!)"
                        print("You are at \(self.currentAddress)")
                        // could read!!!!!--> add speak
                        // check mode and flag, and read !!!!
                        if self.canSpeak {
                            self.canSpeak = false
                            self.speak.speakText(text: "You are at \(self.currentAddress!)")
                            self.canSpeak = true
                        }
                    }
                }
            }
        }
    }
    
    // cite: google places search document: https://developers.google.com/places/web-service/search
    // cite: Alamofire github document: https://github.com/Alamofire/Alamofire
    // cite: SwiftyJSON github documnet: https://github.com/SwiftyJSON/SwiftyJSON
    func fetchLocationInfo(parameters:[String: String]) {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
            else {
                print("wrong url")
                return
        }
        // url request from google place search web, get json, the order of the result depends on the importance
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!")
                guard let data = response.data else {
                    print("data nil")
                    return
                }
                do {
                    let jsonResult = try JSONDecoder().decode(NearbyPlaceJson.self, from: data)
                    self.nearbyPlaces = jsonResult.results
                    
                    self.decideCourse(nearbyPlaces: self.nearbyPlaces)
                } catch {
                    print("error2: \(error)")
                }
            }
            else {
                // networking has problems
                print("Error: \(response.result.error!)")
            }
        }
    }
    
    func decideCourse(nearbyPlaces: [NearbyPlace]) {
        print("decide Course")
        print(nearbyPlaces)
        guard let _ = currentLocation else { return }
        let currentLocationCoordinate = currentLocation!.coordinate
        
        var newFrontPlaces: [NearbyPlace] = []
        var newRightPlaces: [NearbyPlace] = []
        var newBackPlaces: [NearbyPlace] = []
        var newLeftPlaces: [NearbyPlace] = []
        
        for place in nearbyPlaces {
            let placeCoordinate = CLLocationCoordinate2DMake(place.geometry.location.lat, place.geometry.location.lng)
            let bearing = getBearing(heading: (currentLocation?.course)!, currentCoord: currentLocationCoordinate, nearbyPlaceCoord: placeCoordinate)
            
            switch bearing {
            case 0 ..< 45:
                newFrontPlaces.append(place)
            case 45 ..< 135:
                newRightPlaces.append(place)
            case 135 ..< 225:
                newBackPlaces.append(place)
            case 225 ..< 315:
                newLeftPlaces.append(place)
            case 315 ... 360:
                newFrontPlaces.append(place)
            default:
                break
            }
        }
        
        frontPlaces = newFrontPlaces
        rightPlaces = newRightPlaces
        backPlaces = newBackPlaces
        leftPlaces = newLeftPlaces
    }
    
    func getBearing(heading: CLLocationDirection, currentCoord: CLLocationCoordinate2D, nearbyPlaceCoord: CLLocationCoordinate2D) -> Double {
        let vector1: (Double, Double) = (currentCoord.latitude, currentCoord.longitude)
        let vector2: (Double, Double)  = (nearbyPlaceCoord.latitude, nearbyPlaceCoord.longitude)
        let y = vector2.0 - vector1.0
        let x = vector2.1 - vector1.1
        let delta = atan2(abs(x), abs(y)) * 180 / .pi
        
        let headingBearing = heading
        var northPlaceBearing: Double!
        
        if x > Double(0) && y < Double(0) {
            northPlaceBearing = delta
        } else  if x > Double(0) && y > Double(0) {
            northPlaceBearing = Double(180) - delta
        } else if x < Double(0) && y > Double(0) {
            northPlaceBearing = Double(360) - Double(delta)
        } else if x < Double(0) && y < Double(0) {
            northPlaceBearing = Double(180) + delta
        }
            
        else if x == Double(0) && y > Double(0) {
            return 360 - headingBearing
        } else if x == Double(0) && y < Double(0) {
            if headingBearing < Double(180) {
                return Double(180) - headingBearing
            } else if headingBearing >= Double(180) {
                return Double(540) - headingBearing
            }
        } else if y == Double(0) && x > Double(0) {
            if headingBearing < Double(90) {
                return Double(90) - headingBearing
            } else if headingBearing >= Double(90) {
                return Double(450) - headingBearing
            }
        } else if y == Double(0) && x < Double(0) {
            if headingBearing >= Double(270) {
                return Double(630) - headingBearing
            } else if headingBearing < Double(270) {
                return Double(270) - headingBearing
            }
        }
        
        if northPlaceBearing! > Double(headingBearing) {
            return northPlaceBearing! - headingBearing
        } else {
            return Double(360) - (headingBearing - northPlaceBearing!)
        }
    }
    
    
}
