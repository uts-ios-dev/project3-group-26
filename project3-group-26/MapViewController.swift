//
//  MapViewController.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 18/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import AVFoundation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    // API KEYS
    let placeSearchKey = "AIzaSyCXjncpMkQAeoNQRGgDYjoWjLI5MOT7aoI"
    
    // location manager to get location
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var nearbyPlaces: [NearbyPlace] = []
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: text)
    // set speak rate and voice from segue
    // myUtterance.rate = 0.5
    // myUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")

    
    override func viewDidLoad() {
        // using google place key
        GMSPlacesClient.provideAPIKey("AIzaSyCv9RDRR8_GrcvxNurgvkc3XJ68w7nORoU")
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        // the accuracy of the location, set it the best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // start update loation, call the func locationManager
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when location update, call the function
    // the location save in array locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // the most recent location update is at the end of the array, and the accurancy is most best
        let location = locations[locations.count - 1]
        print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        currentLocation = location
        convetToAddress(location: currentLocation!)
        
        // The width and height of a map region.
        // indicate the desired zoom level of the map, with smaller delta values corresponding to a higher zoom level
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocatin: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocatin, span)
        
        // make map move with user
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        // convert location to address
        // placemark contains the place location in CLPlacemark bject
        convetToAddress(location: location)
        
        // using current location to retrive the nearby location via google place search
        if currentLocation == nil {
            return
        }
        let searchLocation: String = "\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)"
        print(searchLocation)
        let searchParams: [String: String] = ["location": searchLocation,"radius": "50", "key": placeSearchKey]
        
        // get nearby places, save in array,
        fetchLocationInfo(parameters: searchParams)
        searchPlace(placeID: "1")
    }
    
    func convetToAddress(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("error")
            } else {
                // print the address: number, street, city, postcode
                if let place = placemark?[(placemark?.count)! - 1] {
                    if let _ = place.subThoroughfare {
                        print("\(place.subThoroughfare!), \(place.thoroughfare!), \(place.locality!), \(place.postalCode!)")
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
//                    print("result array: \(jsonResult.results)")
                    self.nearbyPlaces = jsonResult.results
                    print(self.nearbyPlaces)
                    
                    self.decideDirection(nearbyPlaces: self.nearbyPlaces)
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
    
    
    // cannot working, callback is async, have to make it sync,  --> change it get from json and save
    func searchPlace(placeID: String) {
        let placeID = "ChIJH7WPyCeuEmsRaZs_uxf4eXU"
        placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            // !!! place.coordinate.latitude / longtitude to get the location of the place if the user want to go there following the navigation  !!!!!!
            print("search Place name \(place.name)")
            print("search Place address \(place.formattedAddress!)")
            print("search Place placeID \(place.placeID)")
            print("search Place attributions \(place.coordinate)")
        })
    }
    
    func getCoordnate(placeID: String) -> CLLocationCoordinate2D {
        let placeID = "ChIJH7WPyCeuEmsRaZs_uxf4eXU"
        
        placesClient = GMSPlacesClient.shared()
        var thisPlaceCoor: CLLocationCoordinate2D!
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            // !!! place.coordinate.latitude / longtitude to get the location of the place if the user want to go there following the navigation  !!!!!!
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress!)")
            print("Place placeID \(place.placeID)")
            print("Place attributions \(place.coordinate)")
            thisPlaceCoor = place.coordinate
        })
        return thisPlaceCoor!
    }
    
    func decideDirection(nearbyPlaces: [NearbyPlace]) {
        print("decide Direction")
        print(nearbyPlaces)
        let currentLocation = CLLocationCoordinate2DMake(-33.8841070, 151.2003266)
        for place in nearbyPlaces {
            let placeCoordinate = getCoordnate(placeID: place.place_id)
            decideFrontBack(currentCoord: currentLocation, nearbyPlaceCoord: placeCoordinate)
        }
        
    }
    
    func decideFrontBack(currentCoord: CLLocationCoordinate2D, nearbyPlaceCoord: CLLocationCoordinate2D) {
        let vector1: (Double, Double) = (-1, 1)
        let vector2: (Double, Double)  = (nearbyPlaceCoord.latitude - currentCoord.latitude, nearbyPlaceCoord.longitude - currentCoord.longitude)
        let multi = vector1.0 * vector2.0 + vector1.1 * vector2.1
        if multi > 0 {
            print("front!!")
        }
    }
    
    // refer to coordinate verdict course of the nearby place
    // still has bug!!!
    func decideCourse(nearbyPlaces: [NearbyPlace]) {
        print("decide Course")
        print(nearbyPlaces)
        let currentLocationCoordinate = CLLocationCoordinate2DMake(-33.8841070, 151.2003266)
        for place in nearbyPlaces {
            let placeCoordinate = CLLocationCoordinate2DMake(place.geometry.location.lat, place.geometry.location.lng)
            print(place.name)
            print("get coord: \(placeCoordinate)")
            //            decideFrontBack(currentCoord: currentLocation, nearbyPlaceCoord: placeCoordinate)
            let bearing = getBearing(currentCoord: currentLocationCoordinate, nearbyPlaceCoord: placeCoordinate)
            print("bearing is: \(bearing)")
            
            switch bearing {
            case 0 ..< 45:
                print("at front")
            case 45 ..< 135:
                print("at right")
            case 135 ..< 225:
                print("at back")
            case 225 ..< 315:
                print("at left")
            case 315 ... 360:
                print("at front")
            default:
                break
            }
        }
    }
    
    // add heading: CLHeading,  test just set the heading different orienation
    func getBearing(currentCoord: CLLocationCoordinate2D, nearbyPlaceCoord: CLLocationCoordinate2D) -> Double {
        let vector1: (Double, Double) = (currentCoord.latitude, currentCoord.longitude)
        let vector2: (Double, Double)  = (nearbyPlaceCoord.latitude, nearbyPlaceCoord.longitude)
        let x = vector2.0 - vector1.0
        let y = vector2.1 - vector1.1
        let delta = atan2(abs(x), abs(y))
        print("delta: \(delta)")
        let headingBearing: CLLocationDirection  = 90
        var northPlaceBearing: Double!
        //        if x > 0 && y > 0 {
        //            northPlaceBearing = delta
        //        }
        //        else  if x > 0 && y < 0 {
        //            northPlaceBearing = 180 - delta
        //        } else if x < 0 && y < 0 {
        //            northPlaceBearing = 180 + delta
        //        } else if x < 0 && y > 0 {
        //            northPlaceBearing = 360 - delta
        //        } else if x == 0 && y > 0 {
        //            return 360 - headingBearing
        //        }
        if x > Double(0) && y < Double(0) {
            northPlaceBearing = delta
        } else  if x > Double(0) && y > Double(0) {
            northPlaceBearing = Double(180) - delta
        } else if x < Double(0) && y > Double(0) {
            northPlaceBearing = Double(180) + delta
        } else if x < Double(0) && y < Double(0) {
            northPlaceBearing = Double(360) - Double(delta)
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
