//
//  ViewController.swift
//  project3-group-26
//
//  Created by Zhongtao  Chen on 14/5/18.
//  Copyright © 2018 group-26. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
}


fileprivate extension Selector {
    static let rightSwipeAct = #selector(UIViewController.handleRightSwipe(_:))
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
    
    func rigesterRightSwipe() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: .rightSwipeAct)
        rightSwipe.direction = .right
        rightSwipe.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleRightSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        default:
            break
        }
    }
}



