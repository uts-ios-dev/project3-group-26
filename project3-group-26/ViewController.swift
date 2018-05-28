//
//  ViewController.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 14/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SwipeBackDelegate {
    
    var swipeBackSegue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rigesterRightSwipe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
}


fileprivate extension Selector {
    static let rightSwipeAct = #selector(UIViewController.handleRightSwipe(_:))
}

// single & double 
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

// right swipe
extension UIViewController {

    func rigesterRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: .rightSwipeAct)
        rightSwipe.direction = .right
//        rightSwipe.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(rightSwipe)
    }

    @objc func handleRightSwipe(_ sender: UISwipeGestureRecognizer) {
        
        guard let sbd = self as? SwipeBackDelegate else {
            fatalError("cannot cast")
        }

        switch sender.direction {
        case .right:
            if sbd.swipeBackSegue != "" {
                performSegue(withIdentifier: sbd.swipeBackSegue, sender: self)
            } else {
                print("no swipeBackSegue")
            }
        default:
            break
        }
    }
}



