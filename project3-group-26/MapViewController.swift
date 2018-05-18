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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    // location manager to get location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        // the accuracy of the location, set it the best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // start update loation, call the func
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

   

}
