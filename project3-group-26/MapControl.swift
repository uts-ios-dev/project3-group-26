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
        }
    }
    
    func getFrontPlaces() -> [NearbyPlace] {
        //        let location1 = Location(lat: -33.883706400000001,lng: 151.20050509999999)
        //        let geometry1 = Geometry(location: location1)
        //        let place1 = NearbyPlace(name: "RobotAssist Team", place_id: "ChIJ2ZJWfyiuEmsRhu41187fet0", vicinity: "UTS Building 2, 38/1 Broadway", geometry: geometry1)
        //        let location2 = Location(lat: -33.883808700000003, lng: 151.20022059999999)
        //        let geometry2 = Geometry(location: location2)
        //        let place2 = NearbyPlace(name: "University of Technology Sydney, Building 2", place_id: "ChIJOTvQRyauEmsRjGJ9PYbFjsQ", vicinity: "638 Jones Street, Ultimo", geometry: geometry2)
        //        let place3 = NearbyPlace(name: "Australia-China Relations Institute, University of Technology Sydney", place_id: "ChIJnQucSCauEmsRkkmPkZjvUJg", vicinity: "Tower Building, 18/15 Broadway, Ultimo", geometry: Geometry(location: Location(lat: -33.883780899999998, lng: 151.2002904)))
        //        var testFrontPlaces: [NearbyPlace] = []
        //        testFrontPlaces.append(place1)
        //        testFrontPlaces.append(place2)
        //        testFrontPlaces.append(place3)
        //        return testFrontPlaces
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
        
        
        // The width and height of a map region.
        // indicate the desired zoom level of the map, with smaller delta values corresponding to a higher zoom level
        //        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        //        let myLocatin: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocatin, span)
        
        // make map move with user
        //        map.setRegion(region, animated: true)
        //        self.map.showsUserLocation = true
        
        // convert location to address
        // placemark contains the place location in CLPlacemark object
        //        convetToAddress(location: location)
        
        // using current location to retrive the nearby location via google place search
        if currentLocation == nil {
            return
        }
        let searchLocation: String = "\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)"
        print(searchLocation)
        let searchParams: [String: String] = ["location": searchLocation, "radius": "50", "key": placeSearchKey]
        
        // get nearby places, save in array,
        fetchLocationInfo(parameters: searchParams)
        
        //        locationManager.stopUpdatingLocation()
    }
    
    func convetToAddress(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("error")
            } else {
                // print the address: number, street, city, postcode
                if let place = placemark?[(placemark?.count)! - 1] {
                    if let _ = place.subThoroughfare {
                        let address = "\(place.subThoroughfare!), \(place.thoroughfare!), \(place.locality!), \(place.postalCode!)"
                        print(address)
                        // could read!!!!!--> add speak
                        // check mode and flag, and read !!!!
                    }
                }
            }
        }
    }
    
    func fetchLocationInfo(parameters:[String: String]) {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
            else {
                print("wrong url")
                return
        }
        // url request from google place search web, get json
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
                    //                    print(self.nearbyPlaces)
                    
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
        //        let currentLocationCoordinate = CLLocationCoordinate2DMake(-33.8841070, 151.2003266)          // for test
        guard let _ = currentLocation else { return }
        let currentLocationCoordinate = currentLocation!.coordinate
        for place in nearbyPlaces {
            let placeCoordinate = CLLocationCoordinate2DMake(place.geometry.location.lat, place.geometry.location.lng)
            //            print(place.name)
            //            print("get coord: \(placeCoordinate)")
            let bearing = getBearing(heading: (currentLocation?.course)!, currentCoord: currentLocationCoordinate, nearbyPlaceCoord: placeCoordinate)
            //            print("bearing is: \(bearing)")
            
            switch bearing {
            case 0 ..< 45:
                frontPlaces.append(place)
            //                print("at front")
            case 45 ..< 135:
                rightPlaces.append(place)
            //                print("at right")
            case 135 ..< 225:
                backPlaces.append(place)
            //                print("at back")
            case 225 ..< 315:
                leftPlaces.append(place)
            //                print("at left")
            case 315 ... 360:
                frontPlaces.append(place)
            //                print("at front")
            default:
                break
            }
        }
    }
    
    func getBearing(heading: CLLocationDirection, currentCoord: CLLocationCoordinate2D, nearbyPlaceCoord: CLLocationCoordinate2D) -> Double {
        let vector1: (Double, Double) = (currentCoord.latitude, currentCoord.longitude)
        let vector2: (Double, Double)  = (nearbyPlaceCoord.latitude, nearbyPlaceCoord.longitude)
        let y = vector2.0 - vector1.0
        let x = vector2.1 - vector1.1
        let delta = atan2(abs(x), abs(y)) * 180 / .pi
        //        print("delta: \(delta)")
        //        may use course not the trueHeading
        //        let headingBearing: CLLocationDirection  = heading.trueHeading
        //        let headingBearing: Double  = (currentLocation?.course)!
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
