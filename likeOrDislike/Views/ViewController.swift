//
//  ViewController.swift
//  likeOrDislike
//
//  Created by hanif hussain on 19/10/2023.
//

import UIKit

class ViewController: UITabBarController {
    
    let swipeViewController = SwipeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.barTintColor = .orange
        
        // setup the tab bar display icon for swipe view controller
        swipeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // set swipeViewController in navigation controller
        let swipeViewNavCon = UINavigationController(rootViewController: swipeViewController)
        
        viewControllers = [swipeViewNavCon]
        
    }


}

