import UIKit
import Darwin

struct Response: Codable {
    let potList: [potInfo]
    let reserveList: reserveList
}

struct potInfo: Codable {
    let potId: Int
    let sensorData: sensorData
//    let stateData: stateData
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
    let potId: Int
    let startTime: String
    let controlTime: Int
}

struct lightReserve: Codable {
    let reserveId: Int
    let potId: Int
    let startTime: String
//    let isOn: Bool
}

class ServerAPI {
    static func load(completion: @escaping ([potInfo]) -> Void) {
        // API URL 저장
        let session = URLSession(configuration: .default)
        let requestURL = URL(string: "http://1.251.183.210:3000/view/home")!
        
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
            let stringData = String(data: resultData, encoding: .utf8)
            print(stringData)
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
            print(response.reserveList.waterReserve.first?.startTime)
            return pots
        } catch let error {
            print("parsing error : \(error)")
            return []
        }
    }
}

var pots: [potInfo] = []

ServerAPI.load { pot in
    pots = pot
    print("첫번째 화분 아이디 --> \(pots.first?.potId)")
    print("첫번째 화분 온도 --> \(pots.first?.sensorData.temp)")
    print("첫번째 화분 습도 --> \(pots.first?.sensorData.humi)")
    print("첫번째 화분 토양 습도 --> \(pots.first?.sensorData.soilHumi)")
    print("")
}


//print("첫번째 화분 아이디 --> \(pots.first?.id)")
//print("첫번째 화분 아이디 --> \(pots.first?.id)")

let session = URLSession(configuration: .default)
let requestURL = URL(string: "http://1.251.183.210:3000/view/home")!

// 데이터 테스크 생성
let dataTask = session.dataTask(with: requestURL) { data, response, error in
    // 오류코드 검사
    guard error == nil else {
        print(error?.localizedDescription)
        return
        
    }
    
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
    let successRange = 200..<300
    
    print(statusCode)
    
    // 데이터가 유효한지 확인
    guard let resultData = data else {
        return
    }
    let resultString = String(data: resultData, encoding: .utf8)
    
    print(pots)
}

dataTask.resume()
