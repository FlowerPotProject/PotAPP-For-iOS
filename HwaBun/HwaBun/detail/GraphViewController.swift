//
//  GraphViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/07/13.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate{
    
    var lineChart = LineChartView()
    
    var soilHumiTime: [String] = []
    var soilHumiVal: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        ServerAPI.loadGraghData(potId: 1) { GraphData in
            let soilHumiData: [soilHumiData] = GraphData.soilHumi
            
            for data in soilHumiData {
                self.soilHumiTime.append(data.time)
                self.soilHumiVal.append(data.val)
            }
            DispatchQueue.main.sync {
                self.setChart()
            }
        }
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setChart()
    }
    
    func setChart() {
        // 차트의 레이아웃 지정
        lineChart.frame = CGRect(x: 0, y:0,
                                 width: self.view.frame.size.width,
                                 height: self.view.frame.size.width)
        lineChart.center = view.center
        
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<soilHumiTime.count {
            entries.append(ChartDataEntry(x: Double(x), y: soilHumiVal[x]))
        }

        let set = LineChartDataSet(entries: entries, label: "토양습도")
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
        lineChart.animate(xAxisDuration: 2.5) // 애니메이션
        lineChart.data = data
        print("->>>>>>>>>>> \(self.soilHumiTime)")
        view.addSubview(lineChart)
    }

}
