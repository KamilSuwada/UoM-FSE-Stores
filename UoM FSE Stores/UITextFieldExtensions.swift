//
//  UITextFieldExtensions.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 17/10/2022.
//

import UIKit




extension UITextField
{
    
    func addButton(_ button: UIButton, for location: UITextFieldButtonLocation)
    {
        switch location
        {
        case .left:
            leftView = button
            leftViewMode = .always
        case .right:
            rightView = button
            rightViewMode = .always
        }
    }
    
    
    enum UITextFieldButtonLocation
    {
        case left
        case right
    }
    
}
