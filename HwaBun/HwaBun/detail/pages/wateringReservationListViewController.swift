//
//  wateringReservationListViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

import UIKit

class wateringReservationListViewController: UIViewController {
    let viewModel = wateringReserveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("====> waterReserveList : \(viewModel.waterReserveList)")
    }
    
    func updateList(list: [waterReserve]) {
        viewModel.waterReserveList = list
    }
}

extension wateringReservationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 베이스 생성 시 count로 수정
        return viewModel.waterReserveList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaterReserveCell", for: indexPath) as? WaterReserveCell
        else { return UITableViewCell() }
        
        
        let reserve = viewModel.waterReserveList[indexPath.row]
        cell.updateUI(reserve: reserve)
        
        return cell
    }
    
    
}

extension wateringReservationListViewController: UITableViewDelegate {

}

class WaterReserveCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var modeTypeLabel: UILabel!
    
    func updateUI(reserve: waterReserve) {
        timeLabel.text = "\(reserve.startTime)"
        flowLabel.text = "\(reserve.controlTime)초"
        modeTypeLabel.text = "수동"
    }
    
}

class wateringReserveViewModel {
    var waterReserveList: [waterReserve] = []
    
    func update(list: [waterReserve]) {
        waterReserveList = list
    }
}
