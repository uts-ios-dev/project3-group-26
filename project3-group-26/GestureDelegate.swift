//
//  GuestureDelegate.swift
//  project3-group-26
//
//  Created by Linli Chen on 28/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import Foundation
import UIKit

class GestureDelegate: UIViewController {
    
    var unwindSegueIdentifier: String!
    
    func setUnwindSegueIdentifier(_ identifier: String) {
        unwindSegueIdentifier = identifier
    }
    
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
    
    func rigesterRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: .rightSwipeAct)
        rightSwipe.direction = .right
        rightSwipe.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleRightSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            if unwindSegueIdentifier != nil {
                performSegue(withIdentifier: unwindSegueIdentifier, sender: self)
            }
        default:
            break
        }
    }
    
}

fileprivate extension Selector {
    static let rightSwipeAct = #selector(GestureDelegate.handleRightSwipe(_:))
}
