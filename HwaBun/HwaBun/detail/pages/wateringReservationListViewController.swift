//
//  wateringReservationListViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

import UIKit

class wateringReservationListViewController: UIViewController {
    
    let waterReserveList: [waterReserveInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension wateringReservationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 베이스 생성 시 count로 수정
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaterReserveCell", for: indexPath) as? WaterReserveCell
        else { return UITableViewCell() }
        
//        데이터 생성시 주석 해제
//        let reserve = waterReserveList[indexPath.row]
//        cell.updateUI(reserve: reserve)
        
        return cell
    }
    
    
}

extension wateringReservationListViewController: UITableViewDelegate {

}

struct waterReserveInfo {
    enum Mode: Int {
        case auto = 0
        case manual
    }
    
    let time: TimeInterval
    let flow: Int
    let mode: Mode
}

class WaterReserveCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var modeTypeLabel: UILabel!
    
    func updateUI(reserve: waterReserveInfo) {
        timeLabel.text = "\(reserve.time)"
        flowLabel.text = "\(reserve.flow)"
        modeTypeLabel.text = "\(reserve.mode)"
    }
    
}
