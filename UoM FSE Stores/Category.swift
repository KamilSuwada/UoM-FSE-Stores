//
//  Category.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation; import RealmSwift




class Category: Object
{
// MARK: - Properties:
    
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var isOpened: Bool = false
    var items: List<Item> = List<Item>()
    
    var parentDepartment = LinkingObjects(fromType: Department.self, property: "departmentCatalogue")
    
    
// MARK: - INIT:
    
    
    convenience init(from category: JSONCategory)
    {
        self.init()
        self.id = category.id
        self.name = category.name
        self.isOpened = category.isOpened
        let itemsList = List<Item>()
        for item in category.items
        {
            let realmItem = Item(from: item)
            itemsList.append(realmItem)
        }
        self.items = itemsList
    }
    
    
// MARK: - Methods:
    
    
    public func didTapOnCategory()
    {
        isOpened.toggle()
    }
    
}



class JSONCategory: Codable
{
    // MARK: - Properties:
    
    
    var id: String
    var name: String
    var isOpened: Bool
    var items: Array<JSONItem>
    
    
    // MARK: - INIT:
    
    
    init(id: String, name: String, isOpened: Bool, items: Array<JSONItem>)
    {
        self.id = id
        self.name = name
        self.isOpened = isOpened
        self.items = items
    }
    
}
