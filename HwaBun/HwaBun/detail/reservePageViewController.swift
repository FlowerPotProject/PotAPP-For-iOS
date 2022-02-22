//
//  reservePageViewController.swift
//  HwaBun
//
//  Created by 정승균 on 2022/02/21.
//

import UIKit

class reservePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    var completeHandler: ((Int) -> ())?
    
    let viewList: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "wateringReservationListViewController")
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "lightingReservationListViewController")
        
        return [vc1, vc2]
        
    }()
    
    var currentIndex : Int {
        guard let vc = viewControllers?.first
        else {
            return 0
        }
        
        return viewList.firstIndex(of: vc) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        if let firstvc = viewList.first {
            self.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setViewcontrollersFromIndex(index : Int){
            if index < 0 && index >= viewList.count { return }
            self.setViewControllers([viewList[index]], direction: .forward, animated: true, completion: nil)
            completeHandler?(currentIndex)
        }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewList.firstIndex(of: viewController)
        else {
            return nil
        }
        
        let previousIndex = index - 1
        
        if previousIndex < 0 {
            return nil
        }
        
        return viewList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewList.firstIndex(of: viewController)
        else {
            return nil
        }
        
        let nextIndex = index + 1
        
        if nextIndex == viewList.count { return nil }
        
        return viewList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            completeHandler?(currentIndex)
        }
    }
}
