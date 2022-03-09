//
//  Hwabun.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/17.
//

import UIKit

class PotManager {
    static let shared = PotManager()
    
    static var lastId: Int = 0
    
    var pots: [potInfo] = []
    
    func createPot() {
//        let pot1 = PotInfo(id: 0, humidInfo: 18, tempInfo: 10, soilHumidInfo: 40, isWatering: true, isMainPot: false)
//        let pot2 = PotInfo(id: 1, humidInfo: 30, tempInfo: 25, soilHumidInfo: 29, isWatering: false, isLighting: true, isMainPot: false)
//        let pot3 = PotInfo(id: 2, humidInfo: 40, tempInfo: 39, soilHumidInfo: 15, isWatering: false, isMainPot: true)
//        let pot4 = PotInfo(id: 3, humidInfo: 20, tempInfo: 22, soilHumidInfo: 67, isWatering: true, isMainPot: false)
//
//        self.pots = [pot1, pot2, pot3, pot4]
    }
    
    func loadData(collectionView: UICollectionView) {
        ServerAPI.load { pots in
            self.pots = pots
            DispatchQueue.main.sync {
                collectionView.reloadData()
            }

        }
    }
}

class PotViewModel {
    private let manager = PotManager.shared
    
    var pots: [potInfo] {
        return manager.pots
    }
    
    var mainPot: potInfo {
        return manager.pots.first { pot in
            return pot.stateData.isMainPot == 1
        } ?? manager.pots.first ?? potInfo(potId: 0, sensorData: .init(temp: 0, humi: 0, soilHumi: 0), stateData: .init(isWatering: 0, isLighting: 0, isAuto: 0, isMainPot: 1))
    }
    
    var mainPotIndex: Int? {
        return manager.pots.firstIndex { potInfo in
            return potInfo.stateData.isMainPot == 1
        }
    }
    
    func createPot() {
        manager.createPot()
    }
    
    func loadPot(collectionView: UICollectionView) {
        manager.loadData(collectionView: collectionView)
    }
    
    func loadPotIndex(_ index: Int) -> potInfo {
        return pots[index]
    }
}

// MARK: Home Data
struct Response: Codable {
    let potList: [potInfo]
    let reserveList: reserveList
}

struct potInfo: Codable {
    let potId: Int
    let sensorData: sensorData
    let stateData: stateData
}

struct sensorData: Codable {
    let temp: Float
    let humi: Float
    let soilHumi: Float
}

struct stateData: Codable {
    var isWatering: Int
    var isLighting: Int
    var isAuto: Int
    var isMainPot: Int
}

struct reserveList: Codable {
    let waterReserve: [waterReserve]
    let lightReserve: [lightReserve]
}

struct waterReserve: Codable {
    let reserveId: Int
    let potId: Int
    let startTime: String
    let controlTime: Int
}

struct lightReserve: Codable {
    let reserveId: Int
    let potId: Int
    let startTime: String
    var isOn: Int
}

// MARK: POST Data
struct PostData: Codable {
    let tId: String
    let potId: Int
    let code: String
    let paramsDetail: paramsDetail
}

struct paramsDetail: Codable {
    let setHumi: Int
    let controlTime: Int
    let flux: Int
    let startTime: String
}
