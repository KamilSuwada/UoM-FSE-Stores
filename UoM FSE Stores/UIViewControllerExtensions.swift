//
//  UIViewControllerExtensions.swift
//  Moon Bonsai
//
//  Created by Kamil Suwada on 02/07/2022.
//

import Foundation
import UIKit




extension UIViewController
{
    
    
    func setStatusBar(with colour: UIColor)
    {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = colour
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    
    
    func setTabBarImage(imageName: String, title: String)
    {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
    
    
}
