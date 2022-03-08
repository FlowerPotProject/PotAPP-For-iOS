//
//  waterControlViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/24.
//

import UIKit

class waterControlViewController: UIViewController {
    enum Mode: Int {
        case auto = 0
        case manual = 1
    }
    
    enum ControlType: Int {
        case direct = 0
        case reservation = 1
    }
    
    enum SupplyType: Int {
        case time = 0
        case amount = 1
    }
    
    var potId: Int = 0
    
    var manualModeControlType: ControlType = .direct
    var manualModeSupplyType: SupplyType = .time
    var setReservationTime: Date?
    var isAutoModeOn: Int = 0
    
    @IBOutlet weak var autoModeButton: UIButton!
    @IBOutlet weak var manualModeButton: UIButton!
    @IBOutlet weak var autoModeSettingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var manualModeSettingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var soilHumidSlider: UISlider!
    @IBOutlet weak var soilHumidInput: UITextField!
    @IBOutlet weak var soilControlLabel: UILabel!
    @IBOutlet weak var isAutoModeOnLabel: UILabel!
    @IBOutlet weak var autoModeConfirmButton: UIButton!
    
    @IBOutlet weak var controlMethodSelectButton: UIButton!
    @IBOutlet weak var selectMenu: UIMenu!
    @IBOutlet weak var controlMethodSelectLabel: UILabel!
    @IBOutlet weak var reserveDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var supplyAmountSettingLabel: UILabel!
    @IBOutlet weak var supplyMethodSelectButton: UIButton!
    @IBOutlet weak var waterAmountInput: UITextField!
    @IBOutlet weak var mLLabel: UILabel!
    
    @IBOutlet weak var manualModeConfirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        checkAutoMode()
        setControlMethodButton()
        setSupplyMethodButton()
        setDatePicker()
        self.soilHumidInput.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
    }
    
    // Auto Mode UI제어
    @IBAction func autoModeButtonAction(_ sender: Any) {
        autoModeButton.isSelected = !autoModeButton.isSelected
        let selected = autoModeButton.isSelected
        
        autoModeViewAction(selected: selected)
    }
    
    func checkAutoMode() {
        if isAutoModeOn == 1 {
            autoModeButton.isSelected = true
            autoModeViewAction(selected: autoModeButton.isSelected)
        }
    }
    
    func autoModeViewAction(selected: Bool) {
        viewSize(view: autoModeSettingViewHeight, selected, modeType: .auto)
        
        // 보이게 수정
        soilHumidSlider.isHidden = !selected
        soilHumidInput.isHidden = !selected
        soilControlLabel.isHidden = !selected
        autoModeConfirmButton.isHidden = !selected
        
        // 레이블 상태 변경
        autoModeStatusLabelAction(selected: selected)
    }
    
    func autoModeStatusLabelAction(selected: Bool) {
        if selected {
            isAutoModeOnLabel.text = "ON"
            isAutoModeOnLabel.textColor = UIColor.systemGreen
        }
        else {
            isAutoModeOnLabel.text = "OFF"
            isAutoModeOnLabel.textColor = UIColor.systemRed
        }
    }
    
    // Manual Mode UI제어
    @IBAction func manualModeButtonAction(_ sender: Any) {
        manualModeButton.isSelected = !manualModeButton.isSelected
        let selected = manualModeButton.isSelected
        viewSize(view: manualModeSettingViewHeight, selected, modeType: .manual)
        controlMethodSelectButton.isHidden = !selected
        controlMethodSelectLabel.isHidden = !selected
        supplyAmountSettingLabel.isHidden = !selected
        datePickerHideLogic(selected)
        supplyMethodSelectButton.isHidden = !selected
        manualModeConfirmButton.isHidden = !selected
        waterAmountInput.isHidden = !selected
        mLLabel.isHidden = !selected
    }
    
    func datePickerHideLogic(_ selected: Bool) {
        if selected == true {
            guard let buttonTitle = controlMethodSelectButton.titleLabel?.text else { return }
            if buttonTitle == "예약" {
                reserveDatePicker.isHidden = false
            }
            else {
                reserveDatePicker.isHidden = true
            }
        }
        else {
            reserveDatePicker.isHidden = true
        }
    }
    
    @IBAction func controlSlider(_ sender: Any) {
        let value = soilHumidSlider.value
        soilHumidInput.text = "\(Int(value))"
    }
    
    @objc func textFieldChange(_ sender: Any) {
        guard var convert = Float(self.soilHumidInput.text ?? "50") else {
            return
        }
        if(convert >= 100) {
            soilHumidInput.text = "100"
            convert = 100
        }
        self.soilHumidSlider.setValue(convert, animated: true)
    }
    // 화면 탭 시 키보드 내려감
    @IBAction func tapBG(_ sender: Any) {
        soilHumidInput.resignFirstResponder()
        waterAmountInput.resignFirstResponder()
    }
    
    // 오토 모드 설정 확인
    @IBAction func confirmAutoMode(_ sender: Any) {
        print("오토 모드 설정 완료.")
        print("습도 : \(soilHumidInput.text)%")
        guard let text = soilHumidInput.text else { return }
        guard let setHumi = Int(text) else { return }
        ServerAPI.C_S_001(potId: self.potId, humi: setHumi)
    }
    
    // 메뉴얼 모드 설정 확인
    @IBAction func manualModeConfirm(_ sender: Any) {
        print("메뉴얼 모드 설정 완료.")
        
        guard let textWateringValue = waterAmountInput.text else { return }
        guard let wateringValue = Int(textWateringValue) else { return }
    
        if manualModeControlType == .direct {
            print("즉시 실행")
            if manualModeSupplyType == .time {
                ServerAPI.C_M_001(potId: self.potId, controlTime: wateringValue)
            }
            else {
                ServerAPI.C_M_002(potId: self.potId, flux: wateringValue)
            }
        }
        else {
            print("예약 실행 ---> \(setReservationTime)")
        }

    }
    

    
    func updateUI() {
        // 자동 모드 UI 초기화
        autoModeSettingViewHeight.constant = 0
        soilHumidSlider.isHidden = true
        soilHumidInput.isHidden = true
        soilControlLabel.isHidden = true
        autoModeConfirmButton.isHidden = true
        
        // 화분의 상태에 맞게 변경 (On/Off)
        autoModeStatusLabelAction(selected: false)
        
        // 수동 모드 UI 초기화
        manualModeSettingViewHeight.constant = 0
        controlMethodSelectButton.isHidden = true
        controlMethodSelectLabel.isHidden = true
        supplyAmountSettingLabel.isHidden = true
        reserveDatePicker.isHidden = true
        supplyMethodSelectButton.isHidden = true
        manualModeConfirmButton.isHidden = true
        waterAmountInput.isHidden = true
        mLLabel.isHidden = true
        
        // 텍스트 필드 숫자 키보드
        soilHumidInput.keyboardType = .numberPad
        waterAmountInput.keyboardType = .numberPad
    }
    
    func updateId(id: Int) {
        self.potId = id
    }
    
    func setControlMethodButton() {
        let direct = UIAction(title: "즉시", handler: { _ in
            self.datePickerHeight.constant = 0
            self.reserveDatePicker.isHidden = true
            self.manualModeControlType = .direct
        })
        let reserve = UIAction(title: "예약", handler: { _ in
            self.datePickerHeight.constant = 50
            self.reserveDatePicker.isHidden = false
            self.manualModeControlType = .reservation
        })

        let buttonMenu = UIMenu(title: "제어 방식", children: [direct, reserve])
        
        controlMethodSelectButton.menu = buttonMenu
    }
    
    func setSupplyMethodButton() {
        let time = UIAction(title: "시간", handler: { _ in
            self.waterAmountInput.placeholder = "시간 입력 (초)"
            self.mLLabel.text = "초"
            self.manualModeSupplyType = .time
        })
        
        let amount = UIAction(title: "유량", handler: { _ in
            self.waterAmountInput.placeholder = "유량 입력 (mL)"
            self.mLLabel.text = "mL"
            self.manualModeSupplyType = .amount
        })

        let buttonMenu = UIMenu(title: "공급 유형", children: [time, amount])
        
        supplyMethodSelectButton.menu = buttonMenu
    }
    
    private func setDatePicker() {
        // 1년 뒤 까지 예약 가능
        var maxDateComponents = DateComponents()
        maxDateComponents.year = 1
        reserveDatePicker.maximumDate = Calendar.autoupdatingCurrent.date(byAdding: maxDateComponents, to: Date())
        
        // 과거는 선택 불가
        reserveDatePicker.minimumDate = Date()
        reserveDatePicker.addTarget(self, action: #selector(datePicker(_ :)), for: .valueChanged)
        datePickerHeight.constant = 0
    }
    
    // DatePicker의 값 사용 (데이터 저장 필요)
    @objc func datePicker(_ sender: UIDatePicker) {
        setReservationTime = sender.date
        print(sender.date)
    }
    
    private func viewSize(view: NSLayoutConstraint,_ show: Bool, modeType: Mode) {
        switch modeType {
        case .auto:
            if show {
                view.constant = 150
            }
            else {
                view.constant = 0
            }
        case .manual:
            if show {
                view.constant = 250
            }
            else {
                view.constant = 0
            }
        }
        
    }
    
}
