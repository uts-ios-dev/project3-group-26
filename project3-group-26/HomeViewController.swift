//
//  ViewController.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 14/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, SwipeDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init gesture
        registerSwipe()
        registerButtonTap(button: startButton, singleTapAct: .startButtonST, doubleTapAct: .startButtonDT)
        registerButtonTap(button: settingButton, singleTapAct: .settingButtonST, doubleTapAct: .settingButtonDT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // speech
        if appSetting?.tutorial == .on {
            speechUtil.speakText(text: getPageIntroInDetail())
        } else {
            speechUtil.speakText(text: SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO_SIMPLE, texts: "home"))
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        speechUtil.stopSpeech()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // conform protocals of SwipeDelegate
    func getPageIntroInDetail() -> String {
        var text = SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO,
                                    texts: "home", "select to start navigation or set your perferences")
        text += SpeechUtil.parse(template: SpeechTemplate.PAGE_BUTTON_INFO,
                                 texts: "two top-down buttons", "start and setting", "enter navigation page via start or enter setting page via setting")
        text += SpeechTemplate.GESTURE_INFO + SpeechTemplate.BACK_GESTURE_INFO + SpeechTemplate.REPEAT_GESTURE_INFO
        return text
    }
    
    func getSwipeBackSegue() -> String {
        return ""
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
}

extension HomeViewController {
    @objc func handleStartButtonST(_ sender: UISwipeGestureRecognizer) {
        var text = SpeechUtil.parse(template: SpeechTemplate.BUTTON_INFO, texts: "start")
        text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "enter navigation page")
        speechUtil.speakTextImmediately(text: text)
    }
    
    @objc func handleStartButtonDT(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "segueToVC2_VC1", sender: self)
    }
    
    @objc func handleSettingButtonST(_ sender: UISwipeGestureRecognizer) {
        var text = SpeechUtil.parse(template: SpeechTemplate.BUTTON_INFO, texts: "setting")
        text += SpeechUtil.parse(template: SpeechTemplate.BUTTON_DT_INFO, texts: "enter setting page")
        speechUtil.speakTextImmediately(text: text)
    }
    
    @objc func handleSettingButtonDT(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "segueToVC4_VC1", sender: self)
    }
}


fileprivate extension Selector {
    static let rightSwipeAct = #selector(UIViewController.handleRightSwipe(_:))
    static let downSwipeAct = #selector(UIViewController.handleDownSwipe(_:))
    static let startButtonST = #selector(HomeViewController.handleStartButtonST(_:))
    static let startButtonDT = #selector(HomeViewController.handleStartButtonDT(_:))
    static let settingButtonST = #selector(HomeViewController.handleSettingButtonST(_:))
    static let settingButtonDT = #selector(HomeViewController.handleSettingButtonDT(_:))
}


extension UIViewController {
    
    // single & double
    func registerButtonTap(button: UIButton, singleTapAct: Selector, doubleTapAct: Selector) {
        let singleTap =  UITapGestureRecognizer(target: self, action: singleTapAct)
        singleTap.numberOfTapsRequired = 1
        button.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: doubleTapAct)
        doubleTap.numberOfTapsRequired = 2
        button.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
    }
    
    // swipe
    func registerSwipe() {
        registerDownSwipe()
        registerRightSwipe()
    }
    
    func registerDownSwipe() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: .downSwipeAct)
        downSwipe.direction = .down
//        downSwipe.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc func handleDownSwipe(_ sender: UISwipeGestureRecognizer) {
        guard let sd = self as? SwipeDelegate else {
            fatalError("Type 'ViewController' does not conform to protocol 'SwipeDelegate'")
        }
        speechUtil.speakText(text: sd.getPageIntroInDetail());
    }
    
    func registerRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: .rightSwipeAct)
        rightSwipe.direction = .right
//        rightSwipe.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(rightSwipe)
    }

    @objc func handleRightSwipe(_ sender: UISwipeGestureRecognizer) {
        
        guard let sd = self as? SwipeDelegate else {
            fatalError("Type 'ViewController' does not conform to protocol 'SwipeDelegate'")
        }

        switch sender.direction {
        case .right:
            if sd.getSwipeBackSegue() != "" {
                performSegue(withIdentifier: sd.getSwipeBackSegue(), sender: self)
            } else {
                print("no swipeBackSegue")
            }
        default:
            break
        }
    }
}



