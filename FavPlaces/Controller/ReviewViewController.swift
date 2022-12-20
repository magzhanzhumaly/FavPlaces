//
//  ReviewViewController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 29.11.2022.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(data: restaurant.image)
        
        
        // Добавление эффекта размытия
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // bouncy effect
        //        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
        //            self.rateButtons[0].alpha = 1.0
        //            self.rateButtons[0].transform = .identity
        //        }, completion: nil)
        
        for i in 0..<rateButtons.count {
            
            UIView.animate(withDuration: 0.4, delay: 0.1 + Double(i)*0.05, options: [], animations: {
                self.rateButtons[i].alpha = 1.0
                self.rateButtons[i].transform = .identity
            }, completion: nil)
            
        }
        
    }
    
}
