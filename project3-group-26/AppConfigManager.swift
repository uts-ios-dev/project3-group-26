//
//  SpeechTemplateManager.swift
//  project3-group-26
//
//  Created by Linli Chen on 5/21/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation

public struct AppConfigPList: Codable {
    
    public struct Configuration: Codable {
        public let url: URL?
        public let environment: String
    }
    
    public let configuration: Configuration
    
}

// example code

//do {
//    let appPList = try PListFile<InfoPList>()
//
//    // then read values
//    let url = appPList.data.configuration.url // it’s an URL
//} catch let err {
//    print(“Failed to parse data: \(err)”)
//}

