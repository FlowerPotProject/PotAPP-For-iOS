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
    
    var potId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(potId)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func statusChangeAction(_ sender: UISegmentedControl) {
        if lightControlButton.selectedSegmentIndex == 0 {
            lightControlButton.selectedSegmentTintColor = UIColor.systemPink
            lightImage.image = UIImage(systemName: "lightbulb")
            ServerAPI.C_M_004(potId: self.potId)
        }
        else {
            lightControlButton.selectedSegmentTintColor = UIColor.systemGreen
            lightImage.image = UIImage(systemName: "lightbulb.fill")
            ServerAPI.C_M_003(potId: self.potId)
        }
    
    }
    
    func updateId(id: Int) {
        self.potId = id
    }

}
