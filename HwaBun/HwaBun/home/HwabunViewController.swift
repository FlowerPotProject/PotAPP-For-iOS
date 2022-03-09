//
//  ViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/16.
//

import UIKit

class HwabunViewController: UIViewController, UIGestureRecognizerDelegate {
    let potViewModel = PotViewModel()
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        potViewModel.loadPot(collectionView: homeCollectionView)
        homeCollectionView.refreshControl = UIRefreshControl()
        homeCollectionView.refreshControl?.addTarget(self, action: #selector(refreshPage(_:)), for: .valueChanged)
    }
}

extension HwabunViewController: UICollectionViewDataSource {
    // 몇개 표시?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return potViewModel.pots.count
    }
    
    // 어떻게 표현?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as? InfoCell else {
            return UICollectionViewCell()
        }
        let pot = potViewModel.loadPotIndex(indexPath.item)
        
        cell.updateUI(pot: pot)
        
        return cell
    }
    
    // 헤더 뷰 표현 방식
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView
            else {
                return UICollectionReusableView()
            }
            header.updateHeaderInfo(with: potViewModel.mainPot)
            header.tapHandler = { () -> () in
                self.performSegue(withIdentifier: "showDetail", sender: self.potViewModel.mainPotIndex)
            }
            
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

// 컬렉션 뷰의 사이즈
extension HwabunViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 12
        let margin: CGFloat = 16
        let width: CGFloat = (collectionView.bounds.width - itemSpacing - margin * 2) / 2
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
}

extension HwabunViewController: UICollectionViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? detailViewController
            if let index = sender as? Int {
                let potInfo = potViewModel.loadPotIndex(index)
                
                vc?.viewModel.update(model: potInfo)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        print("홈으로")
    }
    
    @objc func refreshPage(_ sender: UIRefreshControl) {
        print("화면 갱신")
        potViewModel.loadPot(collectionView: homeCollectionView)
        sender.endRefreshing()
        print("완료")
    }
}


class InfoCell: UICollectionViewCell {
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var soilHumidLabel: UILabel!
    @IBOutlet weak var isWatering: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func updateUI(pot: potInfo) {
        self.contentView.layer.borderColor = UIColor.systemGray3.cgColor
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.cornerRadius = 15.0
        humidLabel.text = "\(Int(pot.sensorData.humi))%"
        tempLabel.text = "\(Int(pot.sensorData.temp))℃"
        soilHumidLabel.text = "\(Int(pot.sensorData.soilHumi))%"
        isWatering.text = pot.stateData.isWatering == 1 ? "급수중" : "대기중"
        idLabel.text = "No. \(pot.potId)"
    }
    
}


