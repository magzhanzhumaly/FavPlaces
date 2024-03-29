//
//  RestaurantDiffableDataSource.swift
//  FavPlaces
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

}

    
    // MARK: do this to delete with swipe
    
    /* old --> only allows to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let restaurant = self.itemIdentifier(for: indexPath) {
                var snapshot = self.snapshot()
                snapshot.deleteItems([restaurant])
                self.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    */
    
    // new is written in restarauntViewCOntrller, it extends UITableViewDelegate, and allows swipe-for-more
    
    
