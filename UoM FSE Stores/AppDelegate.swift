//
//  AppDelegate.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import UIKit; import RealmSwift



@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    
    
    /// Main View Controller stores all VCs of the app in a Tab Bar Controller.
    let VC: MainVC =
    {
        let VC = MainVC()
        VC.setStatusBar(with: .systemBackground)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = .systemBackground
        return VC
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        configureWindow()
        window?.rootViewController = VC
        return true
    }
    
    
    
    // MARK: Methods for configuration:
    
    
    
    /// Window configuration method.
    private func configureWindow()
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
    }
    
    
}

