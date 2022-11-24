//
//  ViewController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 17.11.2022.
//

import UIKit

class RestaurantViewController: UIViewController {

    enum Section {
        case all
    }

    @IBOutlet var tableView: UITableView!
    
    lazy var dataSource = configureDataSource()
    var restaurants:[Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei", isFavorite: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
        Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haigh", isFavorite: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palomino", isFavorite: false),
        Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional", isFavorite: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)
    ]
    
    
    // MARK: - View controller life cycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.cellLayoutMarginsFollowReadableWidth = true

        tableView.dataSource = dataSource
       
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        tableView.separatorStyle = .none

    }

    
    
    // MARK: - UITableView Diffable Data Source

    func configureDataSource() -> UITableViewDiffableDataSource<Section, Restaurant> {
     
//        let cellIdentifier = "datacell"
        let cellIdentifier = "favoritecell"
     

        /*old
        let dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurantName in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

//                cell.textLabel?.text = restaurantName
//                cell.imageView?.image = UIImage(named: restaurantName)
     
                cell.nameLabel.text = restaurantName
                cell.locationLabel.text = self.restaurantLocations[indexPath.row]
                cell.typeLabel.text = self.restaurantTypes[indexPath.row]
                cell.thumbnailImageView.image = UIImage(named: self.restaurantImages[indexPath.row])
                


                // to get rid of the repeating ticks
                cell.accessoryType = self.restaurantIsFavorites[indexPath.row] ? .checkmark : .none

                return cell
            }
        ) */
     
        let dataSource = UITableViewDiffableDataSource<Section, Restaurant>(
                tableView: tableView,
                cellProvider: {  tableView, indexPath, restaurant in
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
         
                    cell.nameLabel.text = restaurant.name
                    cell.locationLabel.text = restaurant.location
                    cell.typeLabel.text = restaurant.type
                    cell.thumbnailImageView.image = UIImage(named: restaurant.image)
                    cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
         
                    return cell
                }
            )

        return dataSource
    }

}


// MARK: - UITableViewDelegate Protocol.

extension RestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Создаем меню опций
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .alert)
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        
        // to make .actionSheet open in iPad
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }

        
        // Добавляем действия в меню
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        
        
        
        // Добавьте действие "Зарезервировать столик"
        let reserveActionHandler = { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature is not available yet. Please retry later..", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)

        
        
        
        // Пометить как любимое действие
        /* old
        let favoriteAction = UIAlertAction(title: "Отметить как любимое", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
         
            let cell = tableView.cellForRow(at: indexPath)
                    
            self.restaurantIsFavorites[indexPath.row] = !self.restaurantIsFavorites[indexPath.row]

            cell
            cell?.accessoryType = self.restaurantIsFavorites[indexPath.row] ? .checkmark : .none
        })
        
         */
        
        let favoriteActionTitle = self.restaurants[indexPath.row].isFavorite ? "Remove from favorites" : "Mark as favorite"
        
        let favoriteAction = UIAlertAction(title: favoriteActionTitle, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
         
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
         
            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
         
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
         
        })
        optionMenu.addAction(favoriteAction)
        
        // Отображение меню
        present(optionMenu, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
