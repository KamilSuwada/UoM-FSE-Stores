//
//  User.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 24/10/2022.
//

import Foundation




class User
{
// MARK: - Properties:
    
    
    static var name: String?
    {
        get { return UserDefaults.standard.string(forKey: "user_name") }
        set { UserDefaults.standard.set(newValue, forKey: "user_name") }
    }
    
    
    static var lab: String?
    {
        get { return UserDefaults.standard.string(forKey: "user_lab") }
        set { UserDefaults.standard.set(newValue, forKey: "user_lab") }
    }
    
    
    static var primaryChargeAccount: String?
    {
        get { return UserDefaults.standard.string(forKey: "user_code") }
        set { UserDefaults.standard.set(newValue, forKey: "user_code") }
    }
    
    
    static var aaCode: String?
    {
        get { return UserDefaults.standard.string(forKey: "user_aaCode") }
        set { UserDefaults.standard.set(newValue, forKey: "user_aaCode") }
    }
    
}
