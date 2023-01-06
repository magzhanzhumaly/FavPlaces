//
//  ReviewViewController.swift
//  FavPlaces
//
//  Created by Magzhan Zhumaly on 29.11.2022.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
//            @IBOutlet var awesomeButton: UIButton!
    
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(data: restaurant.image)
        
//        rateButtons[0]. setImage(UIImage(named: "love"), for: .normal)
//        rateButtons[0].setImage(UIImage(named: "love"), for: .highlighted)

//        rateButtons[0].
//        ?.image = UIImage(nasmed: "angry")
        
//        self.setImage(UIImage(named: iconName), for: .normal)
//           self.setImage(UIImage(named: iconName), for: .highlighted)
//           let imageWidth = self.imageView!.frame.width
//           let textWidth = (title as NSString).size(attributes:[NSFontAttributeName:self.titleLabel!.font!]).width
//           let width = textWidth + imageWidth + 24
//           //24 - the sum of your insets from left and right
//           widthConstraints.constant = width
//           self.layoutIfNeeded()

        
        
//        rateButtons[0].imageView?.
//        awesomeButton.imageView?.frame        = CGRect(x: 20, y: 50, width: view.frame.width - 40, height: 100)
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
