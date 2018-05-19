//
//  Speech.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 18/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation
import AVFoundation

let synth = AVSpeechSynthesizer()

let text = "Hello world"
var myUtterance = AVSpeechUtterance(string: text)
//myUtterance.rate = 0.5
//// change code could change language, cannot change gender,
//myUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
//synth.speak(myUtterance)
