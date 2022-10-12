//
//  Category.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation




struct Category: Codable
{
    // MARK: - Properties:
    
    
    var id: String
    var name: String
    var isOpened: Bool
    var items: [Item]
    
    
    // MARK: - Methods:
    
    
    public mutating func didTapOnCategory()
    {
        isOpened.toggle()
    }
}
