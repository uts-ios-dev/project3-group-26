//
//  NavigationViewController.swift
//  project3-group-26
//
//  Created by Linli Chen on 27/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

enum Position {
    case front, back, left, right
}

class NavigationViewController: UIViewController, SwipeDelegate {

    var attemptSpots: [NearbyPlace]!  // param passed to SVVC
    var attemptSpotDict: [Position: [NearbyPlace]]!
    
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    
    var mc = mapControl  // local copy of mapControl in AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // init props
        reset()
        
        // init gesture
        registerSwipe()
        
        // init button action
        registerButtonTap(button: frontButton, singleTapAct: .frontButtonST, doubleTapAct: .frontButtonDT)
        registerButtonTap(button: rightButton, singleTapAct: .rightButtonST, doubleTapAct: .rightButtonDT)
        registerButtonTap(button: backButton, singleTapAct: .backButtonST, doubleTapAct: .backButtonDT)
        registerButtonTap(button: leftButton, singleTapAct: .leftButtonST, doubleTapAct: .leftButtonDT)
        registerButtonTap(button: midButton, singleTapAct: .midButtonST, doubleTapAct: .midButtonDT)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToVC3" {
            let spotVC = segue.destination as! SpotViewController
            spotVC.attemptSpots = attemptSpots
            reset()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mc.activate()  // activate GPS func
        
        // speech
        if appSetting?.tutorial == .on {
            speechUtil.speakText(text: getPageIntroInDetail())
        } else {
            speechUtil.speakText(text: SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO_SIMPLE, texts: "navigation"))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mc.inactivate()  // pause GPS func temperatly
    }
    
    func reset() {
        attemptSpots = []
        attemptSpotDict = [.front: [], .right: [], .back: [], .left: []]
    }
    
    func getSwipeBackSegue() -> String {
        return "unwindSegueToVC1_VC2"
    }
    
    func getPageIntroInDetail() -> String {
        var text = SpeechUtil.parse(template: SpeechTemplate.PAGE_INFO,
                                    texts: "navigation", "clarify where you are currently, and access hot spots in four directions")
        text += SpeechUtil.parse(template: SpeechTemplate.PAGE_BUTTON_INFO,
                                 texts: "5 evenly separated buttons", "front, back, left, right and center", "tapped them on the corresponding area on the screen. Please be noted that center is surrounded by four direction and is used to toggle auto boardcast current position, whereas the other four are used to access hot spots information briefly")
        text += SpeechTemplate.GESTURE_INFO + SpeechTemplate.GESTURE_BACK + SpeechTemplate.GESTURE_REPEAT
        return text
    }
    
    @IBAction func unwindToVC2(segue:UIStoryboardSegue) { }
}


fileprivate extension Selector {
    static let frontButtonST = #selector(NavigationViewController.handleFrontButtonST(_:))
    static let frontButtonDT = #selector(NavigationViewController.handleFrontButtonDT(_:))
    static let rightButtonST = #selector(NavigationViewController.handleRightButtonST(_:))
    static let rightButtonDT = #selector(NavigationViewController.handleRightButtonDT(_:))
    static let backButtonST = #selector(NavigationViewController.handleBackButtonST(_:))
    static let backButtonDT = #selector(NavigationViewController.handleBackButtonDT(_:))
    static let leftButtonST = #selector(NavigationViewController.handleLeftButtonST(_:))
    static let leftButtonDT = #selector(NavigationViewController.handleLeftButtonDT(_:))
    static let midButtonST = #selector(NavigationViewController.handleMidButtonST(_:))
    static let midButtonDT = #selector(NavigationViewController.handleMidButtonDT(_:))
}

extension NavigationViewController {
    
    func handlePositionButtonST(of pos: Position, refresh: Bool) {
        
        if refresh {
            setAttemptSpots(of: pos)
            for spot in attemptSpots {
                print(spot.name)
            }
        }
        
        var spotText = ""
        if attemptSpots != nil {  // spots loaded
            for (i, spot) in attemptSpots.enumerated() {
                if i != 0 && i == attemptSpots.count - 2 {
                    spotText += spot.name + " and "
                } else {
                    spotText += spot.name + ", "
                }
            }
            
            // remove last ", "
            let endIndex = spotText.index(spotText.endIndex, offsetBy: -2)
            spotText = String(spotText[..<endIndex])
        }
        
        let text = SpeechUtil.parse(template: SpeechTemplate.SPOT_INFO,
                                    texts: String(describing: pos),
                                    String(attemptSpots.count),
                                    spotText)
        print(text)
        speechUtil.speakTextImmediately(text: text)
    }
    
    func handlePositionButtonDT(of pos: Position) {
        // avoid direct DT (not ST first)
        if attemptSpots.count == 0 {
            setAttemptSpots(of: pos)
        }
        
        // double check
        if attemptSpots.count == 0 {
            handlePositionButtonST(of: pos, refresh: false)
        } else {
            performSegue(withIdentifier: "segueToVC3", sender: self)
        }
    }
    
    func setAttemptSpots(of pos: Position) {
        switch pos {
        case .front:
            attemptSpotDict[.front] = mc.getFrontPlaces()
        case .right:
            attemptSpotDict[.right] = mc.getRightPlaces()
        case .back:
            attemptSpotDict[.back] = mc.getBackPlaces()
        case .left:
            attemptSpotDict[.left] = mc.getLeftPlaces()
        }
        attemptSpots = attemptSpotDict[pos]
    }
}


// button mapping func
extension NavigationViewController {
    
    @objc func handleFrontButtonST(_ sender: UITapGestureRecognizer) {
        handlePositionButtonST(of: .front, refresh: true)
    }
    
    @objc func handleFrontButtonDT(_ sender: UITapGestureRecognizer) {
        handlePositionButtonDT(of: .front)
    }
    
    @objc func handleRightButtonST(_ sender: UITapGestureRecognizer) {
        handlePositionButtonST(of: .right, refresh: true)
    }
    @objc func handleRightButtonDT(_ sender: UITapGestureRecognizer) {
        handlePositionButtonDT(of: .right)
    }
    
    @objc func handleBackButtonST(_ sender: UITapGestureRecognizer) {
        handlePositionButtonST(of: .back, refresh: true)
    }
    @objc func handleBackButtonDT(_ sender: UITapGestureRecognizer) {
        handlePositionButtonDT(of: .back)
    }
    
    @objc func handleLeftButtonST(_ sender: UITapGestureRecognizer) {
        handlePositionButtonST(of: .left, refresh: true)
    }
    @objc func handleLeftButtonDT(_ sender: UITapGestureRecognizer) {
        handlePositionButtonDT(of: .left)
    }
    
    @objc func handleMidButtonST(_ sender: UITapGestureRecognizer) {
        
        // should be button introduction
        
        // but now changed to currect location introduction tmperately
        if mc.isAutoSpeaking() {
            speechUtil.speakTextImmediately(text: "Auto boardcast is now on. " + SpeechUtil.parse(template: SpeechTemplate.GESTURE_DOUBLE_TAP, texts: "turn it off"))
        } else {
            if let curLoc = mc.getCurrentLocation() {
                speechUtil.speakTextImmediately(text: "You are at \(curLoc)")
            }
        }
    }
    
    // switch auto-speaking on/off
    @objc func handleMidButtonDT(_ sender: UITapGestureRecognizer) {
        mc.toggleAutoSpeaking()
        
        // say status
        let status = mc.isAutoSpeaking() ? "on" : "off"
        speechUtil.speakTextImmediately(text: "Auto boardcast is now \(status). ")
    }
}


