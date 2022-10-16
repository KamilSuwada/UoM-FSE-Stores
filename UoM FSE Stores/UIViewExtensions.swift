//
//  UIViewExtensions.swift
//  Moon Bonsai
//
//  Created by Kamil Suwada on 31/07/2022.
//

import UIKit




extension UIView
{
    
    /// Static method makes any view into a circle.
    static public func makeCircle (view: UIView) {
        view.clipsToBounds = true
        let height = view.frame.size.height
        let width = view.frame.size.width
        let newHeight = min(height, width)
        
        var rectFrame = view.frame
        rectFrame.size.height = newHeight
        rectFrame.size.width = newHeight
        view.frame = rectFrame
        view.layer.cornerRadius = newHeight / 2
    }
    
}
