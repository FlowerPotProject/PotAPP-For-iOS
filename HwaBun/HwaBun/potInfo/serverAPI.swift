//
//  serverAPI.swift
//  HwaBun
//
//  Created by 정승균 on 2022/03/04.
//

import UIKit

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
    let temp: Float
    let humi: Float
    let soilHumi: Float
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
    let reserveId: Int
    let id: Int
    let startTime: TimeInterval
    let controlTime: Int
}

struct lightReserve: Codable {
    let reserveId: Int
    let id: Int
    let startTime: TimeInterval
    let isOn: Bool
}

class ServerAPI {
    static func load(completion: @escaping ([potInfo]) -> Void) {
        // API URL 저장
        let session = URLSession(configuration: .default)
        let requestURL = URL(string: "")!
        
        // 데이터 테스크 생성
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            // 오류코드 검사
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode)
            else { return }
            
            // 데이터가 유효한지 확인
            guard let resultData = data else {
                completion([])
                return
            }
            let pots = ServerAPI.parseData(resultData)
            
            // 데이터를 로드한 후 실행할 클로저
            completion(pots)
        }
        
        dataTask.resume()

    }
    
    static func parseData(_ data:Data) -> [potInfo] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let pots = response.potList
            return pots
        } catch let error {
            print("parsing error : \(error.localizedDescription)")
            return []
        }
    }
}
