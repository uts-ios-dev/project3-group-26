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
        registerButtonTap(button: speechRateButton, singleTapAct: .rateButtonST, doubleTapAct: .rateButtonDT)
        registerButtonTap(button: speechGenderButton, singleTapAct: .genderButtonST, doubleTapAct: .genderButtonDT)
        registerButtonTap(button: tutorialButton, singleTapAct: .tutorialButtonST, doubleTapAct: .tutorialButtonDT)
        
        // speech
        let viewDescription = """
                              This page is setting page, you are going to change speech rate, voice gender
                              and switch tutorial. The page is divided into 3 top-down items, which are
                              speech rate, voice gender and tutorial switch respectively. You can single tap
                              to access details of each items, double tap to change their value or right swpie
                              to go back to home page.
                              """
        print(viewDescription)
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

