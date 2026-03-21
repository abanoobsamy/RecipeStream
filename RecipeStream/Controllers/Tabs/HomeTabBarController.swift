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
        homeNav.isNavigationBarHidden = true
        homeNav.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house.fill"),
                                          tag: 0)
        
        let searchVC = SearchVC()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.isNavigationBarHidden = true
        searchNav.tabBarItem = UITabBarItem(title: "Search",
                                            image: UIImage(systemName: "magnifyingglass"),
                                            tag: 1)
        
        let favoritesVC = FavoriteVC()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.isNavigationBarHidden = true
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorite",
                                               image: UIImage(systemName: "heart"),
                                               selectedImage: UIImage(systemName: "heart.fill"))
        
        let profileVC = ProfileVC()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.isNavigationBarHidden = true
        profileNav.tabBarItem = UITabBarItem(title: "Profile",
                                             image: UIImage(systemName: "person"),
                                             selectedImage: UIImage(systemName: "person.fill"))
        
        // 3. إضافة الشاشات للـ Tab Bar
        viewControllers = [homeNav, searchNav, favoritesNav, profileNav]
    }
}
