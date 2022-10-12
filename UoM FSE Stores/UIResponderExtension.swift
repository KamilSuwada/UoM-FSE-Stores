//
//  UIResponderExtension.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/10/2022.
//

import UIKit




extension UIResponder
{
    private struct Static
    {
        static weak var responder: UIResponder?
    }
    
    
    static func currentFirst() -> UIResponder?
    {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    
    @objc private func _trap()
    {
        Static.responder = self
    }
}
