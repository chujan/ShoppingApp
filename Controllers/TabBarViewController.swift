//
//  TabBarViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 06/12/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    var data = [ProfileViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = ProfileViewController()
        let vc4 = ConversationViewController()
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Profile"
        vc4.title = "Chats"
        
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 1)
        setViewControllers([nav1, nav2, nav3, nav4], animated: false)
        

       
    }
    

    

}

