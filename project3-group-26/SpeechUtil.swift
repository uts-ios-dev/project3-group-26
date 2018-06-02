//
//  File.swift
//  project3-group-26
//
//  Created by Linli Chen on 2/6/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation

class SpeechUtil {
    
    // use default place holder - "%@"
    static func parse(template: String, texts: String...) -> String {
        return parse(template: template, placeHolder: "%@", texts: texts)
    }
    
    static func parse(template: String, placeHolder: String, texts: String...) -> String {
        return parse(template: template, placeHolder: placeHolder, texts: texts)
    }
    
    static func parse(template: String, placeHolder: String, texts: [String]) -> String {
        var tmp = template
        for text in texts {
            tmp = tmp.replaceFirstOccurrence(of: placeHolder, with: text)
            print(tmp)
        }
        return tmp
    }
    
}

extension String {
    func replaceFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
}

