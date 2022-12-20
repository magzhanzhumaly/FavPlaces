//
//  NavigationController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 29.11.2022.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
}
