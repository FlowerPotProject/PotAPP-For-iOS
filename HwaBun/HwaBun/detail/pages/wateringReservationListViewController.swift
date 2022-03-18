//
//  wateringReservationListViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

import UIKit

class wateringReservationListViewController: UIViewController {
    let viewModel = wateringReserveViewModel()
    @IBOutlet weak var waterReservationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("====> waterReserveList : \(viewModel.waterReserveList)")
    }
    
    func updateList(list: [waterReserve]) {
        viewModel.waterReserveList = list
        DispatchQueue.main.async {
            print("updateList ====> \(self.viewModel.waterReserveList)")
            self.waterReservationTable.reloadData()
        }
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
    func sendData(data: [waterReserve]) {
        print("ddddd")
        updateList(list: data)
    }
}

class WaterReserveCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var modeTypeLabel: UILabel!
    
    func updateUI(reserve: waterReserve) {
        let startTime = decodeDate(date: reserve.startTime)
        
        timeLabel.text = "\(startTime)"
        flowLabel.text = "\(reserve.flux)mL"
        modeTypeLabel.text = "수동"
    }
    
    func decodeDate(date: String) -> String {
        let monthRange = date.index(date.startIndex, offsetBy: 5)...date.index(date.startIndex, offsetBy: 6)
        let dayRange = date.index(date.startIndex, offsetBy: 8)...date.index(date.startIndex, offsetBy: 9)
        let timeRange = date.index(date.startIndex, offsetBy: 11)...date.index(date.startIndex, offsetBy: 15)
        
        let returnDate = "\(date[monthRange]).\(date[dayRange]) \(date[timeRange])"
        
        print(returnDate)
        return returnDate
    }
    
}

class wateringReserveViewModel {
    var waterReserveList: [waterReserve] = []
    
    func update(list: [waterReserve]) {
        waterReserveList = list
    }
}
