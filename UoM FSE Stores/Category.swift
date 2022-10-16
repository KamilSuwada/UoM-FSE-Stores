//
//  Category.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation




class Category: Codable
{
    // MARK: - Properties:
    
    
    var id: String
    var name: String
    var isOpened: Bool
    var items: [Item]
    
    
    // MARK: - Methods:
    
    
    // MARK: - INIT:
    
    
    init(id: String, name: String, isOpened: Bool, items: Array<Item>)
    {
        self.id = id
        self.name = name
        self.isOpened = isOpened
        self.items = items
    }
    
    
    public func didTapOnCategory()
    {
        isOpened.toggle()
    }
}
