//
//  Hwabun.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/17.
//

import UIKit

struct PotInfo {
    let id: Int
    var humidInfo: Double
    var tempInfo: Double
    var soilHumidInfo: Double
    var isWatering: Bool = false
    var isLighting: Bool = false
    var isMainPot: Bool
    var img: UIImage = UIImage(named: "potImg")!
}

class PotManager {
    static let shared = PotManager()
    
    static var lastId: Int = 0
    
    var pots: [PotInfo] = []
    
    func createPot() {
        let pot1 = PotInfo(id: 0, humidInfo: 18, tempInfo: 10, soilHumidInfo: 40, isWatering: true, isMainPot: false)
        let pot2 = PotInfo(id: 1, humidInfo: 30, tempInfo: 25, soilHumidInfo: 29, isWatering: false, isLighting: true, isMainPot: false)
        let pot3 = PotInfo(id: 2, humidInfo: 40, tempInfo: 39, soilHumidInfo: 15, isWatering: false, isMainPot: true)
        let pot4 = PotInfo(id: 3, humidInfo: 20, tempInfo: 22, soilHumidInfo: 67, isWatering: true, isMainPot: false)
        
        self.pots = [pot1, pot2, pot3, pot4]
    }
}

class PotViewModel {
    private let manager = PotManager.shared
    
    var pots: [PotInfo] {
        return manager.pots
    }
    
    var mainPot: PotInfo {
        return manager.pots.first { pot in
            return pot.isMainPot == true
        } ?? PotInfo(id: 0, humidInfo: 0, tempInfo: 0, soilHumidInfo: 0, isWatering: false, isMainPot: true)
    }
    
    var mainPotIndex: Int? {
        return manager.pots.firstIndex { PotInfo in
            return PotInfo.isMainPot == true
        }
    }
    
    func createPot() {
        manager.createPot()
    }
    
    func loadPot(_ index: Int) -> PotInfo {
        return pots[index]
    }
}
