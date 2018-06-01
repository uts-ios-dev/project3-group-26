//
//  speechUtilitise.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 1/6/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation

class speechUtilise {
    
    func replaceOne(string: String, placeHolder: String, replaceString: String) -> String {
        let templet = string
        return templet.replacingOccurrences(of: placeHolder, with: replaceString)
    }
    
    func replaceAll(string: String, placeHolders: [String], replaceStrings: [String]) -> String {
        var templet = string
        var finalTemplet = ""
        for i in 0 ... placeHolders.count - 1 {
            templet = templet.replacingOccurrences(of: placeHolders[i], with: replaceStrings[i])
        }
        return templet
    }
}
