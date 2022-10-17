//
//  MainVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import UIKit


extension Notification.Name
{
    static let dataDidChange = Notification.Name("DataDidChange")
}


class MainVC: UITabBarController
{
    // MARK: - PROPERTIES:
    
    
    /// Data catalogue.
    let catalogue = Catalogue()
    
    
    // MARK: - VC LIFE CYLCE:
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupViews()
        self.setupTabBar()
    }
    
}




// MARK: - SETUP
extension MainVC
{
    
    private func setupViews()
    {
        let basketVC = BasketVC(self.catalogue)
        basketVC.setTabBarImage(imageName: "archivebox.fill", title: "Basket")
        
        
        let catalogueVC = CatalogueVC(self.catalogue)
        catalogueVC.setTabBarImage(imageName: "tray.2.fill", title: "Catalouge")
        
        
        let orderVC = UIViewController()
        orderVC.setTabBarImage(imageName: "doc.text.fill", title: "Order")
        
        
        let aboutVC = UIViewController()
        aboutVC.setTabBarImage(imageName: "info.circle.fill", title: "About")
        
        
        
        let basketNC = UINavigationController(rootViewController: basketVC)
        hideNavigationBarLine(basketNC.navigationBar)
        basketNC.navigationBar.tintColor = .systemPurple
        
        
        let catalogueNC = UINavigationController(rootViewController: catalogueVC)
        hideNavigationBarLine(catalogueNC.navigationBar)
        catalogueNC.navigationBar.tintColor = .systemPurple
        
        
        let orderNC = UINavigationController(rootViewController: orderVC)
        hideNavigationBarLine(orderNC.navigationBar)
        orderNC.navigationBar.tintColor = .systemPurple
        
        
        let aboutNC = UINavigationController(rootViewController: aboutVC)
        hideNavigationBarLine(aboutNC.navigationBar)
        aboutNC.navigationBar.tintColor = .systemPurple
        
        
        
        viewControllers = [catalogueNC, basketNC, orderNC, aboutNC]
    }
    
    
    private func setupTabBar()
    {
        tabBar.tintColor = .systemPurple
        tabBar.isTranslucent = false
    }
    
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar)
    {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = false
    }
    
}




