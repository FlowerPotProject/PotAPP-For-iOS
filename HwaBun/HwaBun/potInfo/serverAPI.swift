//
//  serverAPI.swift
//  HwaBun
//
//  Created by 정승균 on 2022/03/04.
//

import UIKit


class ServerAPI {
    
    static let successRange = 200..<300
    // 현재 시간
    static var nowTime: String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"

        var resultTimeLog = dateFormatter.string(from: nowDate)
        resultTimeLog.insert("T", at: resultTimeLog.index(resultTimeLog.startIndex, offsetBy: 10))
        
        return resultTimeLog
    }
    
// MARK: HOME - GET /view/home
    // 서버에 저장된 모든 화분 정보 로드
    static func load(completion: @escaping ([potInfo]) -> Void) {
        // API URL 저장
        let session = URLSession(configuration: .default)
        let requestURL = makeURLRequest(api: "/view/home", isPost: false)
        
        
        // 데이터 테스크 생성
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            // 오류코드 검사
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
            print(pots)
            completion(pots)
        }
        
        dataTask.resume()

    }
    
    // 해당 화분의 정보만 로드
    static func loadOnlyPot(potId: Int, completion: @escaping (potInfo) -> Void) {
        let session = URLSession(configuration: .default)
        let requestURL = makeURLRequest(api: "/view/home", isPost: false)
        
        // 데이터 테스크 생성
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            // 오류코드 검사
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode)
            else { return }
            
            // 데이터가 유효한지 확인
            guard let resultData = data else {
                return
            }
            let pot = ServerAPI.parseDataOnlyPot(potId: potId,resultData)
            
            // 데이터를 로드한 후 실행할 클로저
            print(pot)
            completion(pot)
        }
        
        dataTask.resume()
    }
    
// MARK: Control System C_S_00X
    static func C_S_001(potId: Int, humi: Int) {
        print("---> 자동 급수 C_S_001 시작, tid : \(nowTime), potid : \(potId), setHumi: \(humi)")
        
        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "C_S_001", paramsDetail: .init(setHumi: humi, controlTime: 0, flux: 0, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
    static func C_S_002(potId: Int) {
        print("---> 자동 급수 C_S_002 종료, tid : \(nowTime), potid : \(potId)")
        
        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "C_S_002", paramsDetail: .init(setHumi: 0, controlTime: 0, flux: 0, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
// MARK: Control Manager C_M_00X
    static func C_M_001(potId: Int, controlTime: Int) {
        print("---> 즉시 급수 C_M_001 시작, tid : \(nowTime), potid : \(potId), time: \(controlTime)")

        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        // 데이터 파싱
        let requestData = PostData(tId: nowTime, potId: potId, code: "C_M_001", paramsDetail: .init(setHumi: 0, controlTime: controlTime, flux: 0, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        print("uploadData : \(String(data: uploadData, encoding: .utf8))")
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
    
    static func C_M_002(potId: Int, flux: Int) {
        print("---> 즉시 급수 C_M_002 시작, tid : \(nowTime), potid : \(potId), 유량: \(flux)mL")

        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "C_M_002", paramsDetail: .init(setHumi: 0, controlTime: 0, flux: flux, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
    
    static func C_M_003(potId: Int) {
        print("---> 조명 제어 C_M_003 시작, tid: \(nowTime), potId: \(potId)")
        
        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "C_M_003", paramsDetail: .init(setHumi: 0, controlTime: 0, flux: 0, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
    
    static func C_M_004(potId: Int) {
        print("---> 조명 제어 C_M_004 종료, tid: \(nowTime), potId: \(potId)")
        
        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "C_M_004", paramsDetail: .init(setHumi: 0, controlTime: 0, flux: 0, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
//MARK: Reserve Manager R_M_00X
    static func R_M_001(potId: Int, controlTime: Int, startTime: String) {
        print("---> 예약 급수 R_M_001 시작, tid : \(nowTime), potid : \(potId), time: \(controlTime), startTime: \(startTime)")
        
        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "R_M_001", paramsDetail: .init(setHumi: 0, controlTime: controlTime, flux: 0, startTime: startTime))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
    static func R_M_002(potId: Int, flux: Int, startTime: String) {
        print("---> 예약 급수 R_M_002 시작, tid : \(nowTime), potid : \(potId), flux: \(flux), startTime: \(startTime)")
        
        let requestURL = makeURLRequest(api: "/control/code", isPost: true)
        
        let requestData = PostData(tId: nowTime, potId: potId, code: "R_M_002", paramsDetail: .init(setHumi: 0, controlTime: 0, flux: flux, startTime: startTime))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        postTasks(url: requestURL, uploadData: uploadData)
    }
    
//MARK: Method for Post Tasks
    // requestURL만들기
    static func makeURLRequest(api: String, isPost: Bool) -> URLRequest {
        var requestURL = URLRequest(url: URL(string: "http://203.250.32.29:3000\(api)")!)
        if isPost {
            requestURL.httpMethod = "POST"
            requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return requestURL
    }
    
    
    // postTask 실행
    static func postTasks(url: URLRequest, uploadData: Data){
        let session = URLSession(configuration: .default)
        
        let uploadTask = session.uploadTask(with: url, from: uploadData) { data, response, error in
            guard error == nil
            else {
                print("-----> upload task error : \(error)")
                return
                
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode)
            else { return }
            print("statusCode: \(statusCode)")
        }
        
        uploadTask.resume()
    }
    
// MARK: Data Parsing
    static func parseData(_ data:Data) -> [potInfo] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let pots = response.potList
            return pots
        } catch let error {
            print("parsing error : \(error)")
            return []
        }
    }
    
    
    static func parseDataOnlyPot(potId: Int, _ data: Data) -> potInfo {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let pot = response.potList.first { potInfo in
                return potInfo.potId == potId
            }!
            
            return pot
        } catch let error {
            print("parsing error : \(error)")
            return potInfo(potId: -1, sensorData: .init(temp: -1, humi: -1, soilHumi: -1), stateData: .init(isWatering: -1, isLighting: -1, isAuto: -1, isMainPot: -1))
        }
    }
}
