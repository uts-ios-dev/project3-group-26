//
//  SettingViewController.swift
//  project3-group-26
//
//  Created by Linli Chen on 19/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

enum Gener {
    case male, female
}

struct Setting {
    var rate: SpeechRate
    var gender: Gener
    var tutorial: Bool
}

enum SpeechRate: Float {
    case slow = 0.3
    case normal = 0.5
    case fast = 0.8
    
}

class SettingViewController: UIViewController {

    var setting: Setting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load setting
        let defaultSetting = Setting(rate: .normal, gender: .female, tutorial: true)
        setting = userDefaults.object(forKey:"Setting") as? Setting ?? defaultSetting
        
        // swipe
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = .right
//        rightSwipe.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(rightSwipe)
        
        // hightlight setting button
        
        // speech
    }

    // other 6 buttons
    // ...
    @IBAction func onButtonTapped(_ sender: Any) {
        print("on")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // save when exit
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: setting)
        userDefaults.set(encodedData, forKey: "Setting")
    }
    

}

extension SettingViewController {
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .right:
            performSegue(withIdentifier: "GoLeft", sender: self)
        default:
            break
        }
    }
    
}
