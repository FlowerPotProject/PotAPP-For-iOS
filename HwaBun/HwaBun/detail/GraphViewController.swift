//
//  GraphViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/07/13.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate{
    let chartDataTypeNames: [String] = ["토양습도 (%)", "대기습도 (%)", "대기온도 (℃)"]
    let chartPeriodicalTypeNames: [String] = ["일간", "주간", "월간"]
    
    var lineChart = CombinedChartView()
    var soilHumi: [soilHumiData] = []
    var humi: [humiData] = []
    var temp: [tempData] = []
    
    var controlLog: [String] = []
    
    @IBOutlet weak var periodicalModeSelectButton: UIButton!
    @IBOutlet weak var dataTypeSelectButton: UIButton!
    @IBOutlet weak var chartTitleLabel: UILabel!
    
    var periodicalType: periodicalType = .daily
    var dataType: dataType = .soilHumi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 옵션 설정
        setPeriodicalModeSelectButton()
        setDataTypeSelectButton()
        
        lineChart.delegate = self
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
// MARK: 차트 세팅
    func drawChart(type: dataType) {
        // 차트의 레이아웃 지정
        lineChart.frame = CGRect(x: 0, y:0,
                                 width: self.view.frame.size.width - 30,
                                 height: self.view.frame.size.width)
        // 차트 테두리
        lineChart.borderLineWidth = 0.8
        lineChart.drawBordersEnabled = true
        lineChart.borderColor = .black
        lineChart.center = view.center
        
        // Data Entry 설정
        var lineEntries = [ChartDataEntry]()
        var barEntries = [ChartDataEntry]()
        if type == .soilHumi {
            var count = 0
            
            for x in 0..<soilHumi.count {
                lineEntries.append(ChartDataEntry(x: Double(x), y: soilHumi[x].val))
                
                // soilHumi/daily 일 때 물 주는 로그도 같이 띄움
                if self.periodicalType == .daily,
                   count < self.controlLog.count,
                   soilHumi[x].time == controlLog[count]
                {
                    barEntries.append(BarChartDataEntry(x: Double(x), y: soilHumi[x].val))
                    count += 1
                }
            }
            
        }
        else if type == .temp {
            for x in 0..<temp.count {
                lineEntries.append(ChartDataEntry(x: Double(x), y: temp[x].val))
            }
        }
        else {
            for x in 0..<humi.count {
                lineEntries.append(ChartDataEntry(x: Double(x), y: humi[x].val))
            }
            
        }
        
        // Data Set 설정
        let lineSet = LineChartDataSet(entries: lineEntries)
        lineSet.label = chartDataTypeNames[type.rawValue]
        lineSet.colors = setChartColor(type: type)
        lineSet.highlightEnabled = false // 선택 안되게
        lineSet.drawCirclesEnabled = false // 동그라미 없애기
        lineSet.mode = .cubicBezier // 애니메이션 형태
        
        let barSet = BarChartDataSet(entries: barEntries)
        barSet.label = "급수 시점"
        barSet.colors = [.systemBlue]
        barSet.highlightEnabled = false // 선택 안되게
        let barData = BarChartData(dataSet: barSet)
        barData.barWidth = 0.8
        
        // Chart Data 설정
        let data = CombinedChartData()
        data.lineData = LineChartData(dataSet: lineSet)
        data.barData = barData
        data.setDrawValues(false)
        
        // Chart 속성 설정
        lineChart.doubleTapToZoomEnabled = false // 줌 안되게
        lineChart.xAxis.labelPosition = .bottom // x축 레이블 위치 아래로
        lineChart.xAxis.valueFormatter = setIndexAxisValue(type: type) // x축 레이블 포메터 지정
        lineChart.rightAxis.enabled = false // 우측 레이블 제거
        lineChart.animate(xAxisDuration: 0.3) // 애니메이션
        lineChart.data = data
        view.addSubview(lineChart)
    }
    
    // 데이터 타입에 맞는 차트 색 선정 메서드
    func setChartColor(type: dataType) -> [UIColor] {
        switch type {
        case .temp:
            return [UIColor.systemPink]
        case .humi:
            return [UIColor.systemGreen]
        case .soilHumi:
            return [UIColor.systemBrown]
        }
    }
    
    // 시간 레이블 설정 메서드
    func setIndexAxisValue(type: dataType) -> IndexAxisValueFormatter {
        var time: [String] = []
        
        switch type {
        case .temp:
            for data in temp {
                time.append(data.time)
            }
            return IndexAxisValueFormatter(values: time)
        case .humi:
            for data in humi {
                time.append(data.time)
            }
            return IndexAxisValueFormatter(values: time)
        case .soilHumi:
            for data in soilHumi {
                time.append(data.time)
            }
            return IndexAxisValueFormatter(values: time)
        }
    }

// MARK: 데이터 관련 세팅
    enum dataType: Int {
        case soilHumi = 0
        case humi = 1
        case temp = 2
    }
    
    enum periodicalType: String {
        case daily = "day"
        case weekly = "week"
        case monthly = "month"
    }
    
    func setPeriodicalModeSelectButton() {
        let daily = UIAction(title: "일간", handler: { _ in
            self.periodicalType = .daily
        })
        
        let weekly = UIAction(title: "주간", handler: { _ in
            self.periodicalType = .weekly
        })
        
        let monthly = UIAction(title: "월간") { _ in
            self.periodicalType = .monthly
        }

        let buttonMenu = UIMenu(title: "주기 선택", children: [daily, weekly, monthly])
        
        periodicalModeSelectButton.menu = buttonMenu
    }
    
    func setDataTypeSelectButton() {
        let soilHumi = UIAction(title: "토양습도", handler: { _ in
            self.dataType = .soilHumi
        })
        
        let humi = UIAction(title: "대기습도", handler: { _ in
            self.dataType = .humi
        })
        
        let temp = UIAction(title: "대기온도", handler: { _ in
            self.dataType = .temp
        })
        
        let buttonMenu = UIMenu(title: "데이터 유형", children: [soilHumi, humi, temp])
        
        dataTypeSelectButton.menu = buttonMenu
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        print("데이터 요청 확인")
        loadData()
    }
    
    func loadData() {
        ServerAPI.loadGraghData(potId: 1, periodical: self.periodicalType.rawValue) { [self] GraphData in
            
            self.controlLog = []
            self.soilHumi = GraphData.soilHumi
            self.temp = GraphData.temp
            self.humi = GraphData.humi
            
            let controlLog: [log] = GraphData.log
            for data in controlLog {
                self.controlLog.append(data.time)
            }
            
            print(self.controlLog)
            
            var periodicalType: String
            if self.periodicalType == .daily {
                periodicalType = "일간"
            }
            else if self.periodicalType == .weekly {
                periodicalType = "주간"
            }
            else {
                periodicalType = "월간"
            }
            
            
            DispatchQueue.main.sync {
                self.drawChart(type: self.dataType)
                self.chartTitleLabel.text = "\(periodicalType)/\(chartDataTypeNames[self.dataType.rawValue])"
            }
        }
    }

}
