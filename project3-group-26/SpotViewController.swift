//
//  SpotViewController.swift
//  project3-group-26
//
//  Created by Linli Chen on 27/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, SwipeDelegate {
    
    
    var attemptSpots: [NearbyPlace]!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    var spotButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init gesture
        registerSwipe()
        registerButtonTap(button: firstButton, singleTapAct: .firstButtonST, doubleTapAct: .firstButtonDT)
        registerButtonTap(button: secondButton, singleTapAct: .secondButtonST, doubleTapAct: .secondButtonDT)
        registerButtonTap(button: thirdButton, singleTapAct: .thirdButtonST, doubleTapAct: .thirdButtonDT)
        
        // init button array
        spotButtons.append(firstButton)
        spotButtons.append(secondButton)
        spotButtons.append(thirdButton)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // init button title
        for (i, spot) in attemptSpots.enumerated() {
            if i >= 3 { break }
            spotButtons[i].setTitle(spot.name, for: .normal)
        }
        
        // speech
        if appSetting?.tutorial == .on {
            speechUtil.speakTextImmediately(text: getPageIntroInDetail())
        } else {
            speechUtil.speakTextImmediately(text: SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO_SIMPLE, texts: "spot"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        speechUtil.stopSpeech()
    }
    
    // conform protocals of SwipeDelegate
    func getSwipeBackSegue() -> String {
        return "unwindSegueToVC2_VC3"
    }
    
    func getPageIntroInDetail() -> String {
        var text = SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO,
                                    texts: "spot", "get more information of spot you are interested")
        text += SpeechUtil.parse(template: SpeechTemplate.PAGE_BUTTON_INFO,
                                 texts: "\(attemptSpots.count) top-down buttons", "showing the rank of top \(attemptSpots.count)", SpeechTemplate.GESTURE_INFO + SpeechTemplate.GESTURE_BACK + SpeechTemplate.GESTURE_REPEAT)
        return text
    }
}

fileprivate extension Selector {
    static let firstButtonST = #selector(SpotViewController.handleFirstButtonST(_:))
    static let firstButtonDT = #selector(SpotViewController.handleFirstButtonDT(_:))
    static let secondButtonST = #selector(SpotViewController.handleSecondButtonST(_:))
    static let secondButtonDT = #selector(SpotViewController.handleSecondButtonDT(_:))
    static let thirdButtonST = #selector(SpotViewController.handleThirdButtonST(_:))
    static let thirdButtonDT = #selector(SpotViewController.handleThirdButtonDT(_:))
}

extension SpotViewController {
    
    func handleSpotButtonST(spot: NearbyPlace) {
        let text = SpeechUtil.parse(template: SpeechTemplate.BUTTON_INFO,
                                    texts: spot.name)
        
        speechUtil.speakTextImmediately(text: text)
    }
    
    func handleSpotButtonDT(spot: NearbyPlace) {
        spotControl.fetchDescription(spot: spot.name)
    }
    
    @objc func handleFirstButtonST(_ sender: UITapGestureRecognizer) {
        handleSpotButtonST(spot: attemptSpots[0])
    }
    
    @objc func handleFirstButtonDT(_ sender: UITapGestureRecognizer) {
        handleSpotButtonDT(spot: attemptSpots[0])
    }
    
    @objc func handleSecondButtonST(_ sender: UITapGestureRecognizer) {
        handleSpotButtonST(spot: attemptSpots[1])
    }
    
    @objc func handleSecondButtonDT(_ sender: UITapGestureRecognizer) {
        handleSpotButtonDT(spot: attemptSpots[1])
    }
    
    @objc func handleThirdButtonST(_ sender: UITapGestureRecognizer) {
        handleSpotButtonST(spot: attemptSpots[2])
    }
    
    @objc func handleThirdButtonDT(_ sender: UITapGestureRecognizer) {
        handleSpotButtonDT(spot: attemptSpots[2])
    }
}
