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
    
    @IBOutlet weak var firstSpotButton: UIButton!
    @IBOutlet weak var secondSpotButton: UIButton!
    @IBOutlet weak var thirdSpotButton: UIButton!
    
    var spotButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init gesture
        registerSwipe()
        
        // init button array
        spotButtons.append(firstSpotButton)
        spotButtons.append(secondSpotButton)
        spotButtons.append(thirdSpotButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // init button title
        for (i, spot) in attemptSpots.enumerated() {
            if i >= 3 { break }
            spotButtons[i].setTitle(spot.name, for: .normal)
        }
        
        
    }
    
    // conform protocals of SwipeDelegate
    func getSwipeBackSegue() -> String {
        return "unwindSegueToVC2_VC3"
    }
    
    func getPageIntroInDetail() -> String {
        return ""
    }
}
