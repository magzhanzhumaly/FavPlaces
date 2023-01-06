//
//  RestaurantDetailViewController.swift
//  FavPlaces
//
//  Created by Magzhan Zhumaly on 27.11.2022.
//

import UIKit
import SafariServices  // for SFSafariViewController

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    @IBOutlet var heartButton: UIBarButtonItem!

    @IBOutlet var bookButton: UIButton!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var dislikeButton: UIButton!
    
    @IBOutlet var dislikeCount: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    
    var restaurant: Restaurant = Restaurant()
    
    
    let citiesDict = [         "taraz" : "Тараз",
                               "almaty" : "Алматы",
                               "astana" : "Астана",
                               "shymkent" : "Шымкент",
                               "aktau" : "Актау",
                               "atyrau" : "Атырау",
                               "uralsk" : "Уральск",
                               "aktobe" : "Актобе",
                               "kyzylorda" : "Кызылорда",
                               "kostanay" : "Костанай",
                               "kokshetau" : "Кокшетау",
                               "petropavlovsk" : "Петропавловск",
                               "karaganda" : "Караганда",
                               "ustkam" : "Усть-Каменегорск",
                               "semey" : "Семей",
                               "pavlodar" : "Павлодар"
                               ]

    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        progressBar.progress = 0.8
        progressBar.isHidden = false
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
        
        var phonesString = restaurant.phones.components(separatedBy: ",")

        if phonesString.count > 1 {
            
            var uiActions = [UIAction(title: phonesString[0], state: .on, handler: artTagOptionClosure)]
            
            for i in 1..<phonesString.count {
                uiActions.append(UIAction(title: phonesString[i], handler: artTagOptionClosure))
            }
            
            bookButton.menu = UIMenu(children : uiActions)
            
            bookButton.showsMenuAsPrimaryAction = true
            bookButton.changesSelectionAsPrimaryAction = true
            bookButton.setTitle(String(localized: "Book"), for: .normal)
            
        }
        
        
        likeCount.text = "\(restaurant.likesCount)"
        dislikeCount.text = "\(restaurant.dislikesCount)"
        if restaurant.likesCount == 0 && restaurant.dislikesCount == 0 {
            progressBar.progress = 0
        } else {
            progressBar.progress = Float(restaurant.likesCount / (restaurant.likesCount + restaurant.dislikesCount))
        }
    }
    
    lazy var artTagOptionClosure = {(action : UIAction) in
        self.bookButton.setTitle("Book", for: .normal)
        
        var phone = action.title
        
        let vowels: Set<Character> = ["‒"]
        phone.removeAll(where: { vowels.contains($0) })
        
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.open(number)
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
        var phonesString = restaurant.phones.components(separatedBy: ",")
        var stringToPrint = ""
        for s in phonesString {
            stringToPrint.append(s)
            stringToPrint.append(",\n")
        }
        stringToPrint.removeLast()
        stringToPrint.removeLast()

        print("phonesString \(phonesString.count) = \(phonesString)")
        
        if phonesString.count == 0 {
            return
        } else if phonesString.count == 1 {
            
            var phone = phonesString[0]
            
            let vowels: Set<Character> = ["‒"]
            phone.removeAll(where: { vowels.contains($0) })
            
            guard let number = URL(string: "tel://" + phone) else { return }
            UIApplication.shared.open(number)
            
        } else {
//            var phone = phonesString[0]
//
//            let vowels: Set<Character> = ["‒"]
//            phone.removeAll(where: { vowels.contains($0) })
//
//            guard let number = URL(string: "tel://" + phone) else { return }
//            UIApplication.shared.open(number)
        }

    }
    
    @IBAction func requestMenuTapped(_ sender: UIButton) {
        
//        print("i was here")
        if let whatsappFull = restaurant.whatsapp {
//            openWithSafariViewController(urlString: whatsappFull)
            
            var whatsapp = String("\(whatsappFull.prefix(54))Hello%20I%20am%20texting%20you%20from%20the%20FavPlaces%20app.%20Could%20you%20send%20me%20the%20menu?\(whatsappFull.suffix(31))")
            
            print("whatsapp = \(whatsapp)")
            print("whatsappFull = \(whatsappFull)")

            if let url  = URL(string: whatsapp) {
                if UIApplication.shared.canOpenURL(url as URL)
                {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    print("imhreere")
                }
            }
            
        } else {
            
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        if !restaurant.wasDisliked {

            if restaurant.wasLiked {
                
                restaurant.likesCount -= 1
                likeButton.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)

            } else {

                restaurant.likesCount += 1
                likeButton.setImage(UIImage(systemName: "hand.thumbsup.circle.fill"), for: .normal)
                
            }
            restaurant.wasLiked = !restaurant.wasLiked

            
        } else {
            restaurant.wasDisliked = !restaurant.wasDisliked
            restaurant.dislikesCount -= 1

            restaurant.likesCount += 1
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.circle.fill"), for: .normal)
            dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.circle"), for: .normal)

            restaurant.wasLiked = !restaurant.wasLiked

        }
        likeCount.text = "\(restaurant.likesCount)"
        dislikeCount.text = "\(restaurant.dislikesCount)"

        recalculateProgress()
        
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        if !restaurant.wasLiked {

            if restaurant.wasDisliked {
                
                restaurant.dislikesCount -= 1
                dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.circle"), for: .normal)

            } else {
                
                restaurant.dislikesCount += 1
                dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.circle.fill"), for: .normal)
                
            }
            restaurant.wasDisliked = !restaurant.wasDisliked
            
        } else {
            
            restaurant.wasLiked = !restaurant.wasLiked
            restaurant.wasDisliked = !restaurant.wasDisliked

            restaurant.dislikesCount += 1
            restaurant.likesCount -= 1
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.circle"), for: .normal)
            dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.circle.fill"), for: .normal)


        }
        likeCount.text = "\(restaurant.likesCount)"
        dislikeCount.text = "\(restaurant.dislikesCount)"
        recalculateProgress()
    }
    
    
    func recalculateProgress() {
        if restaurant.likesCount != 0 || restaurant.dislikesCount != 0 {
            progressBar.progress = Float(restaurant.likesCount / (restaurant.likesCount + restaurant.dislikesCount))
        } else {
            progressBar.progress = 0
        }
        restaurant.ratingPercent = Double(progressBar.progress * 100)
        print("restaurant.ratingPercent = \(restaurant.ratingPercent)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func openWithSafariViewController(urlString: String) {
        if let url = URL(string: urlString) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
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
            cell.column2TitleLabel.text = String(localized: "Phone(s)")
            var phonesString = restaurant.phones.components(separatedBy: ",")
            var stringToPrint = ""
            for s in phonesString {
                stringToPrint.append(s)
                stringToPrint.append(",\n")
            }
            stringToPrint.removeLast()
            stringToPrint.removeLast()

            cell.column2TextLabel.text = stringToPrint
            
 
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            if restaurant.url != "nil" {
                cell.configureByURL(location: restaurant.url ?? "")
            } else {
                print("ayioo")
                print("\(citiesDict[restaurant.city]), \(restaurant.location)")
                print("ayioo2")

                cell.configureByLocation(location: "\(citiesDict[restaurant.city] ?? ""), \(restaurant.location)")
            }
            cell.selectionStyle = .none
         
            return cell
 
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
 
        }
    }
}
