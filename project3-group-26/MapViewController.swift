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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    // API KEYS
    let placeSearchKey = "AIzaSyCXjncpMkQAeoNQRGgDYjoWjLI5MOT7aoI"
    
    // location manager to get location
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var nearbyPlaces: [NearbyPlace] = []
    
    
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
        currentLocation = location
        print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        
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
                } catch {
                    print("error2: \(error)")
                }
            }
            else {
                // networking has problemms
                print("Error: \(response.result.error!)")
            }
        }
    }
    
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
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress!)")
            print("Place placeID \(place.placeID)")
            print("Place attributions \(place.attributions!)")
        })
    }

}
