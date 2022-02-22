//
//  LigitingReservationListViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

import UIKit

class lightingReservationListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension lightingReservationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LightingReserveCell", for: indexPath) as? LightingReserveCell
        else {
            return UITableViewCell()
        }
        
        return cell
                
    }
    
    
}

extension lightingReservationListViewController: UITableViewDelegate {
    
}

struct lightingReserve {
    enum Mode: Int {
        case auto = 0
        case manual = 1
    }
    
    let time: TimeInterval
    let mode: Mode
}

class LightingReserveCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
}
