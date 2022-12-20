//
//  RestaurantDetailViewController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 27.11.2022.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    @IBOutlet var heartButton: UIBarButtonItem!

    var restaurant: Restaurant = Restaurant()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none

        navigationController?.navigationBar.prefersLargeTitles = false
        
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(data: restaurant.image)
        
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        heartButton.tintColor = UIColor(named: Colors.accentColor.rawValue)
//        restaurant.isFavorite ? UIColor(named: Colors.accentColor.rawValue) : .white
        heartButton.image = UIImage(systemName: heartImage)
//        heartButton.setBackgroundImage(UIImage(systemName: heartImage), for: .normal, barMetrics: .default)
        
        if let rating = restaurant.rating {
            headerView.ratingImageView.image = UIImage(named: rating.image)
        }
    }

    @IBAction func rateButtonTapped(_ sender: UIBarButtonItem) {
        restaurant.isFavorite.toggle()
        
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        heartButton.tintColor = UIColor(named: Colors.accentColor.rawValue)
//        restaurant.isFavorite ? UIColor(named: Colors.accentColor.rawValue) : .white
        heartButton.image = UIImage(systemName: heartImage)
        
        
        // save changes to the database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
    }
    
    
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        print("book")
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
            
        case "showReview":
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
            
        default: break
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
       
        guard let identifier = segue.identifier else {
            return
        }
     
        dismiss(animated: true, completion: {
     
            if let rating = Restaurant.Rating(rawValue: identifier) {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating.image)
     
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
            }
     
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.headerView.ratingImageView.transform = scaleTransform
            self.headerView.ratingImageView.alpha = 0
     
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.headerView.ratingImageView.transform = .identity
                self.headerView.ratingImageView.alpha = 1
            }, completion: nil)
     
        })
        
    }

}

extension RestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
 
            cell.descriptionLabel.text = restaurant.summary
 
            return cell
 
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoColumnCell.self), for: indexPath) as! RestaurantDetailTwoColumnCell
 
            cell.column1TitleLabel.text = String(localized: "Address")
            cell.column1TextLabel.text = restaurant.location
            cell.column2TitleLabel.text = String(localized: "Phone")
            cell.column2TextLabel.text = restaurant.phone
 
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            cell.configure(location: restaurant.location)
            cell.selectionStyle = .none
         
            return cell
 
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
 
        }
    }
    
    
}
