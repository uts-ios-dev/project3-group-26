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

class NavigationViewController: UIViewController {

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

        // activate GPS func
        mc.activate()
        
        // init props
        attemptSpots = []
        attemptSpotDict = [.front: [], .right: [], .back: [], .left: []]
        
        // init button action
//        registerButtonTap(button: frontButton, singleTapAct: .frontButtonST, doubleTapAct: .frontButtonDT)
//        registerButtonTap(button: rightButton, singleTapAct: .rightButtonST, doubleTapAct: .rightButtonDT)
//        registerButtonTap(button: backButton, singleTapAct: .backButtonST, doubleTapAct: .backButtonDT)
//        registerButtonTap(button: leftButton, singleTapAct: .leftButtonST, doubleTapAct: .leftButtonDT)
//        registerButtonTap(button: midButton, singleTapAct: .midButtonST, doubleTapAct: .midButtonDT)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            let spotVC = segue.destination as! SpotViewController
            spotVC.attemptSpots = attemptSpots
            attemptSpots = nil  // reset
        }
        
        mc.inactivate()  // pause GPS func temperatly
    }
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
        }
        
        // *********
        // speak sth
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
            performSegue(withIdentifier: "", sender: self)
        }
    }
    
    func setAttemptSpots(of pos: Position) {
        switch pos {
        case .back:
            attemptSpotDict[pos] = mc.getBackPlaces()
        case .front:
            attemptSpotDict[pos] = mc.getFrontPlaces()
        case .left:
            attemptSpotDict[pos] = mc.getLeftPlaces()
        case .right:
            attemptSpotDict[pos] = mc.getRightPlaces()
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
            
        } else {
            if let curLoc = mc.getCurrentLocation() {
                // **************
                // speak out loud
            }
        }
    }
    
    // switch auto-speaking on/off
    @objc func handleMidButtonDT(_ sender: UITapGestureRecognizer) {
        mc.toggleAutoSpeaking()
    }
}


