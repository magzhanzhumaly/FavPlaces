//
//  WalkthroughPageViewController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 06.12.2022.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: AnyObject {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {

//    var pageHeadings = [String(localized: "CREATE YOUR OWN FOOD GUIDE"), String(localized: "SHOW YOU THE LOCATION"), String(localized: "DISCOVER GREAT RESTAURANTS")]
//    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
    var pageHeadings = ["Выбирай тысячи заведений в своем городе и добавляй свои. Совершенно бесплатно!", "Находи любимые заведения на карте и ставь свои оценки.", "Делись с друзьями своими любимыми заведениями и добавляй в список новые!"]
    
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
//    var pageSubHeadings = [String(localized: "Pin your favorite restaurants and create your own food guide"),
//                           String(localized: "Search and locate your favourite restaurant on Maps"),
//                           String(localized: "Find restaurants shared by your friends and other foodies")]
//    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide",
//                           "Search and locate your favourite restaurant on Maps",
//                           "Find restaurants shared by your friends and other foodies"]
    var pageSubHeadings = ["",
                           "",
                           ""]

    var currentIndex = 0
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
     
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
 
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
 
        return contentViewController(at: index)
    }
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
 
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
 
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
     
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
     
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            print("pageContentViewController.heading = \(pageContentViewController.heading )")
            
            pageContentViewController.subHeading = pageSubHeadings[index]
            print("pageContentViewController.subHeading = \(pageContentViewController.subHeading )")

            pageContentViewController.index = index
     
            return pageContentViewController
        }
     
        return nil
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}

extension WalkthroughPageViewController: UIPageViewControllerDelegate {
 
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
 
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
 
                currentIndex = contentViewController.index
 
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
 
        }
    }
}
