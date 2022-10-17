//
//  AboveKeyboardView.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 17/10/2022.
//

import UIKit




class AboveKeyboardView: UIView
{
    //MARK: - Properties:
    
    
    /// Style of the users interface.
    private var appearance: UIUserInterfaceStyle?
    
    
    //MARK: - INITs:
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setup()
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        self.appearance = traitCollection.userInterfaceStyle
    }
    
    
    /// To be ovverriden to setup the custom view.
    func setup()
    {
        backgroundColor = .systemPurple
    }

}
