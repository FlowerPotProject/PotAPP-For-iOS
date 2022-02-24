//
//  waterControlViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/24.
//

import UIKit

class waterControlViewController: UIViewController {
    @IBOutlet weak var autoModeButton: UIButton!
    @IBOutlet weak var manualModeButton: UIButton!
    @IBOutlet weak var autoModeSettingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var manualModeSettingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var soilHumidSlider: UISlider!
    @IBOutlet weak var soilHumidInput: UITextField!
    @IBOutlet weak var soilControlLabel: UILabel!
    @IBOutlet weak var soilHumidConfirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    @IBAction func autoModeButtonAction(_ sender: Any) {
        autoModeButton.isSelected = !autoModeButton.isSelected
        let selected = autoModeButton.isSelected
        viewSize(view: autoModeSettingViewHeight, selected)
        print("---> selected : \(selected)")
    }
    
    @IBAction func manualModeButtonAction(_ sender: Any) {
        manualModeButton.isSelected = !manualModeButton.isSelected
        let selected = manualModeButton.isSelected
        viewSize(view: manualModeSettingViewHeight, selected)
        // 보이게 수정
        soilHumidSlider.isHidden = !selected
        soilHumidInput.isHidden = !selected
        soilControlLabel.isHidden = !selected
        soilHumidConfirmButton.isHidden = !selected
    }
    
    @IBAction func controlSlider(_ sender: Any) {
        let value = soilHumidSlider.value
        soilHumidInput.text = "\(Int(value))"
        
    }
    
    func updateUI() {
        autoModeSettingViewHeight.constant = 0
        manualModeSettingViewHeight.constant = 0
        soilHumidSlider.isHidden = true
        soilHumidInput.isHidden = true
        soilControlLabel.isHidden = true
        soilHumidConfirmButton.isHidden = true
    }
    
    private func viewSize(view: NSLayoutConstraint,_ show: Bool) {
        if show {
            view.constant = 150
        }
        else {
            view.constant = 0
        }
    }
    
    
    
}
