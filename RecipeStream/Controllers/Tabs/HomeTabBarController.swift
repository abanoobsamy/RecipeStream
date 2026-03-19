//
//  HomeTabBarController.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 15/03/2026.
//

import UIKit
import SwiftUI

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomTabBar()
        setupViewControllers()
    }
    
    private func setupCustomTabBar() {
        tabBar.tintColor = UIColor(.colorRedGray)
        tabBar.unselectedItemTintColor = .systemGray        
    }
    
    private func setupViewControllers() {
        
        // الشاشة الأولى: الوصفات (Home)
        let homeVC = HomeVC()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house.fill"),
                                          tag: 0)
        
        let searchVC = UIViewController() // default vc for now
        searchVC.view.backgroundColor = .systemBlue
        searchVC.title = "Search"
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(title: "Search",
                                            image: UIImage(systemName: "magnifyingglass"),
                                            tag: 1)
        
        let favoritesVC = UIViewController() // default vc for now
        favoritesVC.view.backgroundColor = .systemBlue
        favoritesVC.title = "Favorite"
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorite",
                                               image: UIImage(systemName: "heart"),
                                               selectedImage: UIImage(systemName: "heart.fill"))
        
        let profileVC = UIViewController() // default vc for now
        profileVC.view.backgroundColor = .systemBlue
        profileVC.title = "Profile"
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile",
                                             image: UIImage(systemName: "person"),
                                             selectedImage: UIImage(systemName: "person.fill"))
        
        // 3. إضافة الشاشات للـ Tab Bar
        viewControllers = [homeNav, searchNav, favoritesNav, profileNav]
    }
}
