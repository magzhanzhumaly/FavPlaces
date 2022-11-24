//
//  RestaurantDiffableDataSource.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 24.11.2022.
//

import UIKit
 
enum Section {
    case all
}
 
class RestaurantDiffableDataSource: UITableViewDiffableDataSource<Section, Restaurant> {
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 
    }
    
}
