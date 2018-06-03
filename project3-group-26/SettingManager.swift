//
//  SettingManager.swift
//  project3-group-26
//
//  Created by Linli Chen on 20/05/2018.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation

class SettingManager {
    
    static let Instance = SettingManager()
    var setting: Setting!
    
    private init() {
        let gender = Gender(rawValue: userDefaults.object(forKey: "setting_gender") as? String ?? Gender.female.rawValue)
        let tutorial = Switch(rawValue: userDefaults.object(forKey: "setting_tutorial") as? String ?? Switch.on.rawValue)
        let rate = SpeechRate(rawValue: userDefaults.object(forKey: "setting_rate") as? Float ?? SpeechRate.normal.rawValue)
        let autoSpeaking = Switch(rawValue: userDefaults.object(forKey: "setting_autoSpeaking") as? String ?? Switch.on.rawValue)
        
        setting = Setting(rate: rate!, gender: gender!, tutorial: tutorial!, autoSpeaking: autoSpeaking!)
        
    }
    
    func save(_ setting: Setting) {
        self.setting = setting
        appSetting = self.setting;
        
        userDefaults.set(setting.rate.rawValue, forKey: "setting_rate")
        userDefaults.set(setting.gender.rawValue, forKey: "setting_gender")
        userDefaults.set(setting.tutorial.rawValue, forKey: "setting_tutorial")
        userDefaults.set(setting.autoSpeaking.rawValue, forKey: "setting_autoSpeaking")
    }
    
}

struct Setting {
    var rate: SpeechRate
    var gender: Gender
    var tutorial: Switch
    var autoSpeaking: Switch
}

enum SpeechRate: Float {
    case slow = 0.3
    case normal = 0.5
    case fast = 0.8
    
}

enum Gender: String {
    case male = "male"
    case female = "female"
}

enum Switch: String {
    case on = "on"
    case off = "off"
}


