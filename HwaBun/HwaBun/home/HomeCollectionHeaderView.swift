//
//  HomeCollectionHeaderView.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/17.
//

import UIKit

class HomeCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerHumidLabel: UILabel!
    @IBOutlet weak var headerTempLabel: UILabel!
    @IBOutlet weak var headerSoilHumidLabel: UILabel!
    @IBOutlet weak var headerIsWatering: UILabel!
    @IBOutlet weak var headerThumbnail: UIImageView!
    @IBOutlet weak var headerInner: UIView!
    @IBOutlet weak var headerPotIdLabel: UILabel!
    
    var mainPot: potInfo?
    var tapHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerThumbnail.layer.cornerRadius = 15
        headerInner.layer.cornerRadius = 15
    }
    
    func updateHeaderInfo(with pot: potInfo) {
        self.mainPot = pot
        
        self.headerHumidLabel.text = "\(pot.sensorData.humi)%"
        self.headerTempLabel.text = "\(pot.sensorData.temp)℃"
        self.headerSoilHumidLabel.text = "\(pot.sensorData.soilHumi)%"
        self.headerIsWatering.text = pot.stateData.isWatering == 1 ? "급수중" : "대기중"
        self.headerPotIdLabel.text = "No. \(pot.potId)"
        self.headerThumbnail.image = UIImage(named: "potImg.jpeg")
        
        updateDate()
    }
    
    func updateDate() {
        let today = Date()
        // 월 정보
        let month = returnMonth(date: today)
        // 일 정보
        let day = returnDay(date: today)
        // 요일 정보
        let dayOfWeek = returnDayOfWeek(date: today)
        
        self.dateLabel.text = "\(dayOfWeek) \(day), \(month)"
    }
    
    func returnMonth(date: Date) -> String {
        let currentMonth = Calendar.current.component(.month, from: date)
        let monthArray: [String] = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        
        return monthArray[currentMonth - 1]
    }
    
    func returnDay(date: Date) -> Int {
        let day = Calendar.current.component(.day, from: date)

        return day
    }
    
    func returnDayOfWeek(date: Date) -> String {
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let dayOfWeekArray: [String] = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
        
        return dayOfWeekArray[dayOfWeek - 1]
    }
    
    @IBAction func cardTapped(_ sender: UIButton) {
        tapHandler?()
    }
}
