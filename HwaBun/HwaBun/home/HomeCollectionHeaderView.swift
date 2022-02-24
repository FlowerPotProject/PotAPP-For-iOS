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
    
    var mainPot: PotInfo?
    var tapHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerThumbnail.layer.cornerRadius = 15
        headerInner.layer.cornerRadius = 15
    }
    
    func updateHeaderInfo(with pot: PotInfo) {
        self.mainPot = pot
        
        self.headerHumidLabel.text = "\(pot.humidInfo)%"
        self.headerTempLabel.text = "\(pot.tempInfo)℃"
        self.headerSoilHumidLabel.text = "\(pot.soilHumidInfo)%"
        self.headerIsWatering.text = pot.isWatering ? "급수중" : "대기중"
        self.headerPotIdLabel.text = "No. \(pot.id + 1)"
        self.headerThumbnail.image = pot.img
        
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
