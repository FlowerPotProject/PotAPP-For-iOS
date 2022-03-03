import UIKit
import Darwin

let session = URLSession(configuration: .default)

let url = URL(string: "http://www.naver.com")!

struct Response: Codable {
    let potList: [potInfo]
    let reserveList: reserveList
}

struct potInfo: Codable {
    let id: Int
    let sensorData: sensorData
    let stateData: stateData
}

struct sensorData: Codable {
    let temp: Int
    let humi: Int
    let soilHumi: Int
}

struct stateData: Codable {
    let isWatering: Bool
    let isLighting: Bool
    let isAuto: Bool
    let isMainPot: Bool
}

struct reserveList: Codable {
    let waterReserve: [waterReserve]
    let lightReserve: [lightReserve]
}

struct waterReserve: Codable {
    
}

struct lightReserve: Codable {
    
}

let dataTask = session.dataTask(with: url) { data, response, error in
    guard error == nil else { return }
    
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
    
    let successRange = 200..<300
    
    guard successRange.contains(statusCode) else {
        return
    }
}
