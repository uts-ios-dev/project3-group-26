//
//  SettingViewController.swift
//  project3-group-26
//
//  Created by Linli Chen on 19/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    var setting: Setting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting = SettingManager.Instance.setting
        
        rigesterRightSwipe()
        registerRateButtonTap()
        registerGenderButtonTap()
        registerTutorialButtonTap()
        
        // speech
        //        let viewDescription = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showButtonTitle()
    }
    
    @IBOutlet weak var speechRateButton: UIButton!
    @IBOutlet weak var speechGenderButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SettingManager.Instance.save(setting)
    }
    
    func showButtonTitle() {
        speechRateButton.setTitle(String(describing: setting.rate).uppercased(), for: .normal)
        speechGenderButton.setTitle(String(describing: setting.gender).uppercased(), for: .normal)
        tutorialButton.setTitle(String(describing: setting.tutorial).uppercased(), for: .normal)
    }
    
}

extension SettingViewController {
    
    func rigesterRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = .right
        //        rightSwipe.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .right:
            performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        default:
            break
        }
    }
    
}

extension SettingViewController {
    
    func registerRateButtonTap() {
        let singleTap =  UITapGestureRecognizer(target: self, action: .rateButtonST)
        singleTap.numberOfTapsRequired = 1
        speechRateButton.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: .rateButtonDT)
        doubleTap.numberOfTapsRequired = 2
        speechRateButton.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        //        singleTap.delaysTouchesBegan = true
        //        doubleTap.delaysTouchesBegan = true
    }
    
    @objc func handleRateButtonSingleTap(_ sender: UITapGestureRecognizer) {
        print("speak rate decription")
    }
    
    @objc func handleRateButtonDoubleTap(_ sender: UITapGestureRecognizer) {
        switch setting.rate {
        case .slow:
            setting.rate = .normal
        case .normal:
            setting.rate = .fast
        case .fast:
            setting.rate = .slow
        }
        showButtonTitle()
    }
    
    func registerGenderButtonTap() {
        let singleTap =  UITapGestureRecognizer(target: self, action: .genderButtonST)
        singleTap.numberOfTapsRequired = 1
        speechGenderButton.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: .genderButtonDT)
        doubleTap.numberOfTapsRequired = 2
        speechGenderButton.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        //        singleTap.delaysTouchesBegan = true
        //        doubleTap.delaysTouchesBegan = true
    }
    
    @objc func handleGenderButtonSingleTap(_ sender: UITapGestureRecognizer) {
        print("speak gender decription")
    }
    
    @objc func handleGenderButtonDoubleTap(_ sender: UITapGestureRecognizer) {
        switch setting.gender {
        case .male:
            setting.gender = .female
        case .female:
            setting.gender = .male
        }
        showButtonTitle()
    }
    
    func registerTutorialButtonTap() {
        let singleTap =  UITapGestureRecognizer(target: self, action: .tutorialButtonST)
        singleTap.numberOfTapsRequired = 1
        tutorialButton.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: .tutorialButtonDT)
        doubleTap.numberOfTapsRequired = 2
        tutorialButton.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        //        singleTap.delaysTouchesBegan = true
        //        doubleTap.delaysTouchesBegan = true
    }
    
    @objc func handleTutorialButtonSingleTap(_ sender: UITapGestureRecognizer) {
        print("speak tutorial decription")
    }
    
    @objc func handleTutorialButtonDoubleTap(_ sender: UITapGestureRecognizer) {
        switch setting.tutorial {
        case .on:
            setting.tutorial = .off
        case .off:
            setting.tutorial = .on
        }
        showButtonTitle()
    }
}

fileprivate extension Selector {
    static let rateButtonST = #selector(SettingViewController.handleRateButtonSingleTap(_:))
    static let rateButtonDT = #selector(SettingViewController.handleRateButtonDoubleTap(_:))
    static let genderButtonST = #selector(SettingViewController.handleGenderButtonSingleTap(_:))
    static let genderButtonDT = #selector(SettingViewController.handleGenderButtonDoubleTap(_:))
    static let tutorialButtonST = #selector(SettingViewController.handleTutorialButtonSingleTap(_:))
    static let tutorialButtonDT = #selector(SettingViewController.handleTutorialButtonDoubleTap(_:))
}

