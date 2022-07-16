//
//  GraphViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/07/13.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate{
    let chartDataTypeNames: [String] = ["토양습도", "대기습도", "대기온도"]
    let chartPeriodicalTypeNames: [String] = ["일간", "주간", "월간"]
    
    var lineChart = LineChartView()
    
    var soilHumiTime: [String] = []
    var soilHumiVal: [Double] = []
    var humiTime: [String] = []
    var humiVal: [Double] = []
    var tempTime: [String] = []
    var tempVal: [Double] = []
    
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
        

        
        var entries = [ChartDataEntry]()
        if type == .soilHumi {
            for x in 0..<soilHumiTime.count {
                entries.append(ChartDataEntry(x: Double(x), y: soilHumiVal[x]))
            }

        }
        else if type == .temp {
            for x in 0..<tempTime.count {
                entries.append(ChartDataEntry(x: Double(x), y: tempVal[x]))
            }
        }
        else {
            for x in 0..<humiTime.count {
                entries.append(ChartDataEntry(x: Double(x), y: humiVal[x]))
            }
            
        }

        let set = LineChartDataSet(entries: entries)
        set.label = chartDataTypeNames[type.rawValue]
        set.colors = [.systemBlue]
        set.highlightEnabled = false // 선택 안되게
        set.drawCirclesEnabled = false // 동그라미 없애기
        set.mode = .cubicBezier // 애니메이션 형태
        lineChart.doubleTapToZoomEnabled = false // 줌 안되게
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChart.xAxis.labelPosition = .bottom // x축 레이블 위치 아래로
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: soilHumiTime) // x축 레이블 포메터 지정
        lineChart.rightAxis.enabled = false // 우측 레이블 제거
        lineChart.animate(xAxisDuration: 0.3) // 애니메이션
        lineChart.data = data
        view.addSubview(lineChart)
    }
    
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
            
            self.soilHumiTime = []
            self.soilHumiVal = []
            self.humiTime = []
            self.humiVal = []
            self.tempTime = []
            self.tempVal = []
            
            let soilHumiData: [soilHumiData] = GraphData.soilHumi
            let humiData: [humiData] = GraphData.humi
            let tempData: [tempData] = GraphData.temp
            
            // 데이터 삽입하기
            for data in soilHumiData {
                self.soilHumiTime.append(data.time)
                self.soilHumiVal.append(data.val)
            }
            for data in humiData {
                self.humiTime.append(data.time)
                self.humiVal.append(data.val)
            }
            for data in tempData {
                self.tempTime.append(data.time)
                self.tempVal.append(data.val)
            }
            
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
