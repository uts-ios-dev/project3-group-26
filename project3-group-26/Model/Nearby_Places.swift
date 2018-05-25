//
//  Nearby_Places.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 20/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation


struct NearbyPlace: Decodable {
    var name: String
    var place_id: String
    var vicinity: String
    var geometry: Geometry
}

struct NearbyPlaceJson: Decodable {
    let results: [NearbyPlace]
    let status: String?
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
}

struct Geometry: Decodable {
    let location: Location
}
