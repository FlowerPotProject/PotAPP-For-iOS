//
//  serverAPI.swift
//  HwaBun
//
//  Created by 정승균 on 2022/03/04.
//

import UIKit


class ServerAPI {
    
    static let successRange = 200..<300
    
    // MARK: HOME - GET /view/home
    // 서버에 저장된 모든 화분 정보 로드
    static func load(completion: @escaping ([potInfo]) -> Void) {
        // API URL 저장
        let session = URLSession(configuration: .default)
        let requestURL = URL(string: "http://1.251.183.210:3000/view/home")!
        
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
    
// MARK: C_M_001 - POST /control/code
    static func C_M_001(tId: String, potId: Int, paramsDetail: Int) {
        print("---> 즉시 급수 C_M_001 시작 tid : \(tId), potid : \(potId), time: \(paramsDetail)")
        
        // 세션 설정
        let session = URLSession(configuration: .default)
        var requestURL = URLRequest(url: URL(string: "http://1.251.183.210:3000/control/code")!)
        requestURL.httpMethod = "POST"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 데이터 파싱
        let requestData = CMData001(tId: tId, potId: potId, paramsDetail: .init(controlTime: paramsDetail, flux: 0, startTime: ""))
        guard let uploadData = try? JSONEncoder().encode(requestData) else { return }
        
        print("uploadData : \(String(data: uploadData, encoding: .utf8))")
        
        let uploadTask = session.uploadTask(with: requestURL, from: uploadData) { data, response, error in
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
}
