//
//  Speech.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 18/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

//Arabic (Saudi Arabia) - ar-SA
//Chinese (China) - zh-CN
//Chinese (Hong Kong SAR China) - zh-HK
//Chinese (Taiwan) - zh-TW
//Czech (Czech Republic) - cs-CZ
//Danish (Denmark) - da-DK
//Dutch (Belgium) - nl-BE
//Dutch (Netherlands) - nl-NL
//English (Australia) - en-AU
//English (Ireland) - en-IE
//English (South Africa) - en-ZA
//English (United Kingdom) - en-GB
//English (United States) - en-US
//Finnish (Finland) - fi-FI
//French (Canada) - fr-CA
//French (France) - fr-FR
//German (Germany) - de-DE
//Greek (Greece) - el-GR
//Hindi (India) - hi-IN
//Hungarian (Hungary) - hu-HU
//Indonesian (Indonesia) - id-ID
//Italian (Italy) - it-IT
//Japanese (Japan) - ja-JP
//Korean (South Korea) - ko-KR
//Norwegian (Norway) - no-NO
//Polish (Poland) - pl-PL
//Portuguese (Brazil) - pt-BR
//Portuguese (Portugal) - pt-PT
//Romanian (Romania) - ro-RO
//Russian (Russia) - ru-RU
//Slovak (Slovakia) - sk-SK
//Spanish (Mexico) - es-MX
//Spanish (Spain) - es-ES
//Swedish (Sweden) - sv-SE
//Thai (Thailand) - th-TH
//Turkish (Turkey) - tr-TR

import Foundation
import AVFoundation
//enum Gender {
//    case male
//    case female
//}

class TextToSpeech : NSObject, AVSpeechSynthesizerDelegate
{
    var text : String!
    var voice_language : String!
    var voice_rate : Float! // from 0.5 to 2, default 1
    var voice_volume : Float!
    var voice_gender : Gender!
    var speechSynthesizer = AVSpeechSynthesizer()
    
    override init()
    {
        text = ""
        voice_language = "en-US"
        voice_rate = 0.6
        voice_volume = 1
        voice_gender = Gender.female
    }
    func speakText(text : String)
    {
        voice_rate = appSetting?.rate.rawValue
        
        if !speechSynthesizer.isSpeaking
        {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: voice_language)
            utterance.rate = voice_rate
            utterance.volume = voice_volume
            // set the time before handling the next queued utterance
            utterance.postUtteranceDelay = 0.1
            speechSynthesizer.speak(utterance)
        }
    }
    
    // Created by Linli Chen on 2/6/18.
    func speakTextImmediately(text: String) {
        stopSpeech()
        speakText(text: text)
    }
    
    func pauseSpeech()
    {
        if speechSynthesizer.isSpeaking
        {
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
    }
    func stopSpeech()
    {
        if speechSynthesizer.isSpeaking || speechSynthesizer.isPaused
        {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            speechSynthesizer = AVSpeechSynthesizer()
        }
    }
    func continueSpeach()
    {
        if speechSynthesizer.isPaused
        {
            speechSynthesizer.continueSpeaking()
        }
    }
    func setVoiceType(voiceLanguageType : String)
    {
        voice_language = voiceLanguageType
    }
    func setRate(rate : Float)
    {
        voice_rate = rate
    }
    func setVolume(volume : Float)
    {
        voice_volume = volume
    }
    
}
