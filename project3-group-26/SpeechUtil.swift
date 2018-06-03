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

struct SpeechTemplate {
    
    static let PAGE_INFO = "This page is %@ page, you can %@. "
    static let PAGE_INFO_SIMPLE = "This page is %@ page. "
    static let PAGE_BUTTON_INFO = "The page is divided into %@, which are %@ button respectively. You can %@. "
    
    static let BUTTON_INFO = "This is %@ button."
    static let BUTTON_ST_INFO = "Single tap to %@. "
    static let BUTTON_DT_INFO = "Double tap to %@. "
    
    static let GESTURE_SINGLE_TAP = "Double tap for more information. "
    static let GESTURE_DOUBLE_TAP = "Signle tap to read content on the button. "
    static let GESTURE_INFO = GESTURE_DOUBLE_TAP + GESTURE_DOUBLE_TAP
    
    static let GESTURE_BACK = "Right swpie to back to last page. "
    static let GESTURE_REPEAT = "Down swipe to listen page introduction again. "
    
    static let SPOT_INFO = "This direction is %@ whose top %@ spots are %@. "
    
    
}
