//
//  reserveListViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

//heello
import UIKit

class reserveListViewController: UIViewController {
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    
    var btnList: [UIButton] = []
    
    var currentIndex: Int = 0 {
        didSet {
            changeBtnColor()
            print(currentIndex)
        }
    }
    
    func setBtnList() {
        waterButton.tintColor = .label
        lightButton.tintColor = .systemGray3

        btnList.append(waterButton)
        btnList.append(lightButton)
    }
    
    func changeBtnColor() {
        if currentIndex == 0 {
            btnList[0].tintColor = .label
            btnList[1].tintColor = .systemGray3
        }
        else {
            btnList[1].tintColor = .label
            btnList[0].tintColor = .systemGray3
        }
    }
    
    var reservePageViewController: reservePageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pageView" {
            guard let vc = segue.destination as? reservePageViewController else { return }
            reservePageViewController = vc
            
            reservePageViewController.completeHandler = { (result) in
                self.currentIndex = result
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnList()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        btnStackView.layer.cornerRadius = 15
        btnList[0].layer.cornerRadius = 15
        btnList[1].layer.cornerRadius = 15
    }
    
    @IBAction func waterBtnAction(_ sender: Any) {
        reservePageViewController.setViewcontrollersFromIndex(index: 0)
    }
    
    @IBAction func lightBtnAction(_ sender: Any) {
        reservePageViewController.setViewcontrollersFromIndex(index: 1)
    }

}
