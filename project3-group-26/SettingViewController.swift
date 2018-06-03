//
//  SettingViewController.swift
//  project3-group-26
//
//  Created by Linli Chen on 19/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, SwipeDelegate {
    
    var setting: Setting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting = SettingManager.Instance.setting
        
        registerSwipe()
        registerButtonTap(button: speechRateButton, singleTapAct: .rateButtonST, doubleTapAct: .rateButtonDT)
        registerButtonTap(button: tutorialButton, singleTapAct: .tutorialButtonST, doubleTapAct: .tutorialButtonDT)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showButtonTitle()
        
        // speech
        if appSetting?.tutorial == .on {
            speechUtil.speakText(text: getPageIntroInDetail())
        } else {
            speechUtil.speakText(text: SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO_SIMPLE, texts: "setting"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        speechUtil.stopSpeech()
    }
    
    @IBOutlet weak var speechRateButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SettingManager.Instance.save(setting)
    }
    
    func showButtonTitle() {
        speechRateButton.setTitle(String(describing: setting.rate).uppercased(), for: .normal)
        tutorialButton.setTitle(String(describing: setting.tutorial).uppercased(), for: .normal)
    }
    
    
    // comform protocals of SwipeDelegate
    func getSwipeBackSegue() -> String {
        return "unwindSegueToVC1_VC4"
    }
    
    func getPageIntroInDetail() -> String {
        var text = SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO,
                                    texts: "setting", "change speaking speed and switch on and off to tutorial")
        text += SpeechUtil.parse(template: SpeechTemplate.PAGE_BUTTON_INFO,
                                 texts: "two top-down buttons", "speed and tutorial", "change speaking speed via speed or turn on and off tutorial via another")
        text += SpeechTemplate.GESTURE_INFO + SpeechTemplate.GESTURE_BACK + SpeechTemplate.GESTURE_REPEAT
        return text
    }
    
}

extension SettingViewController {
    
    
    func saveAndSpeak(_ text: String) {
        SettingManager.Instance.save(setting)
        speechUtil.speakTextImmediately(text: text)
    }
    
    @objc func handleRateButtonSingleTap(_ sender: UITapGestureRecognizer) {
        var text = SpeechUtil.parse(template: SpeechTemplate.BUTTON_INFO, texts: "speed")
        
        switch setting.rate {
        case .slow:
            text += "Currently, speaking speed is slow. "
            text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "normal speed" )
        case .normal:
            text += "Currently, speaking speed is normal. "
            text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "fast speed" )
        case .fast:
            text += "Currently, speaking speed is fast. "
            text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "slow speed" )
        }
        
        speechUtil.speakTextImmediately(text: text)
    }
    
    @objc func handleRateButtonDoubleTap(_ sender: UITapGestureRecognizer) {
        
        switch setting.rate {
        case .slow:
            setting.rate = .normal
            saveAndSpeak("Speaking speed is normal now. ")
        case .normal:
            setting.rate = .fast
            saveAndSpeak("Speaking speed is fast now. ")
        case .fast:
            setting.rate = .slow
            saveAndSpeak("Speaking speed is slow now. ")
        }
        showButtonTitle()
    }
    
    @objc func handleTutorialButtonSingleTap(_ sender: UITapGestureRecognizer) {
        var text = SpeechUtil.parse(template: SpeechTemplate.BUTTON_INFO, texts: "tutorial")
        
        switch setting.tutorial {
        case .on:
            text += "Currently, the tutorial mode is on. "
            text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "turn it off" )
        case .off:
            text += "Currently, the tutorial mode is off. "
            text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "turn it on" )
        }
        
        speechUtil.speakTextImmediately(text: text)
    }
    
    @objc func handleTutorialButtonDoubleTap(_ sender: UITapGestureRecognizer) {
        
        switch setting.tutorial {
        case .on:
            setting.tutorial = .off
            saveAndSpeak("Tutorial is off now. ")
        case .off:
            setting.tutorial = .on
            saveAndSpeak("tutorial is on now. ")
        }
        showButtonTitle()
    }
}

fileprivate extension Selector {
    static let rateButtonST = #selector(SettingViewController.handleRateButtonSingleTap(_:))
    static let rateButtonDT = #selector(SettingViewController.handleRateButtonDoubleTap(_:))
    static let tutorialButtonST = #selector(SettingViewController.handleTutorialButtonSingleTap(_:))
    static let tutorialButtonDT = #selector(SettingViewController.handleTutorialButtonDoubleTap(_:))
}

