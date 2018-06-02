//
//  spotControl.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 2/6/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class spotControl {
    
    let url = URL(string: "https://en.wikipedia.org/w/api.php")
    var parameters: [String: String] = ["action": "query", "prop": "extracts", "format": "json", "exintro": "", "titles": ""]
    var regs = ["<[^>]+>", "\\n", "\\"]
    
    func fetchDescription(spot: String) {
        parameters["titles"] = spot
        
        guard let url = url
            else {
                print("wrong url")
                return
        }
        var description: String?
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!")
                guard let data = response.data else {
                    print("data nil")
                    return
                }
                print(data)
                let jsonData = JSON(data)
                print(jsonData)
                for (key, value) in jsonData["query"]["pages"] {
                    //                    print(value["extract"])
                    description = value["extract"].stringValue
                }
                
                description = self.cleanString(string: description!)
                print(description!)
                // speak
            }
            else {
                // networking has problems
                print("Error: \(response.result.error!)")
            }
        }
    }
    
    func cleanString(string: String) -> String {
        var cleanedString = string
        for reg in regs {
            cleanedString = cleanedString.replacingOccurrences(of: reg, with: "", options: .regularExpression, range: nil)
        }
        return cleanedString
    }
    
}
