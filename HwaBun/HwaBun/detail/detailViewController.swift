//
//  detailViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

import UIKit

class detailViewController: UIViewController {
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var soilHumidLabel: UILabel!


    @IBOutlet weak var wateringView: UIView!
    @IBOutlet weak var wateringImg: UIImageView!
    @IBOutlet weak var wateringInnerView: UIView!
    @IBOutlet weak var isWateringLabel: UILabel!


    @IBOutlet weak var lightingView: UIView!
    @IBOutlet weak var lightImg: UIImageView!
    @IBOutlet weak var lightInnerView: UIView!
    @IBOutlet weak var isLightingLabel: UILabel!

    @IBOutlet weak var reservationView: UIView!


    let viewModel = detailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    func updateUI() {
        statusView.layer.cornerRadius = 15
        statusView.layer.borderColor = UIColor.systemGray3.cgColor
        statusView.layer.borderWidth = 1

        wateringView.layer.cornerRadius = 15
        wateringView.layer.borderColor = UIColor.systemGray3.cgColor
        wateringView.layer.borderWidth = 1
        wateringImg.layer.cornerRadius = 15
        wateringInnerView.layer.cornerRadius = 15

        lightingView.layer.cornerRadius = 15
        lightingView.layer.borderColor = UIColor.systemGray3.cgColor
        lightingView.layer.borderWidth = 1
        lightImg.layer.cornerRadius = 15
        lightInnerView.layer.cornerRadius = 15

        reservationView.layer.cornerRadius = 15
        reservationView.layer.borderColor = UIColor.systemGray3.cgColor
        reservationView.layer.borderWidth = 1


        if let potInfo = viewModel.potInfo {
            humidLabel.text = "\(potInfo.sensorData.humi)%"
            tempLabel.text = "\(potInfo.sensorData.temp)℃"
            soilHumidLabel.text = "\(potInfo.sensorData.soilHumi)%"

            if potInfo.stateData.isWatering == 1 {
                isWateringLabel.text = "ON"
                isWateringLabel.textColor = UIColor.systemGreen
            }
            else {
                isWateringLabel.text = "OFF"
                isWateringLabel.textColor = UIColor.systemRed
            }

            if potInfo.stateData.isLighting == 1 {
                isLightingLabel.text = "ON"
                isLightingLabel.textColor = UIColor.systemGreen
            }
            else {
                isLightingLabel.text = "OFF"
                isLightingLabel.textColor = UIColor.systemRed
            }
        }
    }

    var reserveListViewController: reserveListViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reserveList" {
            let destinationVC = segue.destination as? reserveListViewController
            reserveListViewController = destinationVC
        }
        
        if segue.identifier == "moveWatering" {
            let destinationVC = segue.destination as? waterControlViewController
            guard let id = viewModel.potInfo?.potId else { return }
            destinationVC?.updateId(id: id)
            guard let isAuto = viewModel.potInfo?.stateData.isAuto else { return }
            destinationVC?.isAutoModeOn = isAuto
        }
        
        if segue.identifier == "moveLighting" {
            let destinationVC = segue.destination as? lightControlViewController
            guard let id = viewModel.potInfo?.potId else { return }
            destinationVC?.updateId(id: id)
        }
    }
}

extension detailViewController {
    @IBAction func unwindAndRefresh(segue : UIStoryboardSegue) {
        
    }
}


class detailViewModel {
    var potInfo: potInfo?

    func update(model: potInfo) {
        potInfo = model
    }
}

