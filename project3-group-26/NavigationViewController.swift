//
//  NavigationViewController.swift
//  project3-group-26
//
//  Created by Linli Chen on 27/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {

    
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    
    var mc = mapControl  // local copy of mapControl in AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButtonTap(button: midButton, singleTapAct: Selector.midButtonST, doubleTapAct: Selector.midButtonDT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mc.activate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mc.inactivate()
    }
    
    
}

// extension for all VC to use single/double tap
extension UIViewController {
    
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
    
}

fileprivate extension Selector {
    static let midButtonST = #selector(NavigationViewController.handleMidButtonST(_:))
    static let midButtonDT = #selector(NavigationViewController.handleMidButtonDT(_:))
}

extension NavigationViewController {
    
    
    @objc func handleMidButtonST(_ sender: UITapGestureRecognizer) {
        
        // should be button introduction
        
        // but now changed to currect location introduction tmperately
        if mc.isAutoSpeaking() {
            
        } else {
            // not auto
            if let curLoc = mc.getCurrentLocation() {
                // speak out loud
                print(curLoc)
            }
        }
        
        
    }
    
    // switch auto-speaking on/off
    @objc func handleMidButtonDT(_ sender: UITapGestureRecognizer) {
        mc.toggleAutoSpeaking()
    }
}


