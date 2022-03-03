//
//  lightControlViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/03/03.
//

import UIKit

class lightControlViewController: UIViewController {
    @IBOutlet weak var lightControlButton: UISegmentedControl!
    @IBOutlet weak var lightImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func statusChangeAction(_ sender: UISegmentedControl) {
        if lightControlButton.selectedSegmentIndex == 0 {
            lightControlButton.selectedSegmentTintColor = UIColor.systemPink
            lightImage.image = UIImage(systemName: "lightbulb")
        }
        else {
            lightControlButton.selectedSegmentTintColor = UIColor.systemGreen
            lightImage.image = UIImage(systemName: "lightbulb.fill")
        }
        

    }

}
