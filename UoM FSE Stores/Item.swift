//
//  Item.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation
import RealmSwift



class Item: Object
{
    //MARK: - PROPERTIES:
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var unitIssue: String = ""
    @objc dynamic var price: Double = 0.00
    @objc dynamic var quantity: Int = 0
    @objc dynamic var isFavourite: Bool = false
    @objc dynamic var isPPE: Bool = false
    @objc dynamic var isWaste: Bool = false
    var keywords: Array<String> = Array<String>()
    @objc dynamic var imageName: String = ""
    @objc dynamic var isUsual: Bool = false
    @objc dynamic var usualQuantity: Int = 0
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
    // MARK: - INIT:
    
    
    convenience init(from item: JSONItem)
    {
        self.init()
        self.id = item.id
        self.name = item.name
        self.code = item.code
        self.unitIssue = item.unitIssue
        self.price = item.price
        self.quantity = item.quantity
        self.isFavourite = item.isFavourite
        self.isPPE = item.isPPE
        self.isWaste = item.isWaste
        self.keywords = item.keywords
        self.imageName = item.imageName
    }
    
    
    //MARK: - METHODS:
    
    
    /// Computed property which returns quantity of the item as e.g. x 4
    public var formattedQuantity: String
    {
        return "x \(self.quantity)"
    }
    
    
    /// Formatted price returns quantity * price of the selection as e.g. 12.53
    public var formattedPrice: String
    {
        let amount = self.price * Double(self.quantity)
        return String(format: "%.2f", amount)
    }
    
    
    /// Formatted list price returns price of the selection as e.g. 12.53
    public var formattedListPrice: String
    {
        return String(format: "£%.2f", self.price)
    }
    
    
    /// Method for gneration of a short name: ful name is split into an array by the space character set, then first 4 words are rejoined.
    public var shortName: String
    {
        let words = self.name.components(separatedBy: " ")
        guard words.count >= 3 else { return self.name }
        var result = ""
        
        for i in 0..<3
        {
            if i == 0 { result = words[i] + " " }
            else if i == 1 { result = result + words[i] + " " }
            else { result = result + words[i] }
        }
        
        return result
    }
    
    
    /// Method for increasing quantity by 1.
    public func didTapPlusOne()
    {
        self.quantity += 1
    }
    
    
    /// Method for decreasing the quantity by 1. Only called when quantity is greater than zero: we will not order -1 bottles of DCM.
    public func didTapMinusOne()
    {
        if (self.quantity > 0) { self.quantity -= 1 }
    }
    
    
    /// Method called before calling didTapMinusOne. Will determine if the operation is allowed, for UI updates.
    public func willTapMinusOne() -> Bool
    {
        if (self.quantity > 0) { return true }
        else { return false }
    }
    
    
    /// Method for toggling the selection of an item as favourite.
    public func didTapFavourite()
    {
        self.isFavourite.toggle()
    }
    
    
    /// Method for setting the quantity manually.
    public func changeQuantity(to number: Int)
    {
        guard number >= 0 else { return }
        self.quantity = number
    }
    
    
    
    /// Method for expressing the item as one line, for order.
    public func returnFormattedSelf() -> String
    {
        return "\(self.quantity) x \(self.name)"
    }
    
    
    /// Method makes the order usual.
    public func makeUsual(_ bool: Bool)
    {
        self.isUsual = bool
        if bool { self.usualQuantity = self.quantity }
        else { self.usualQuantity = 0 }
    }
    
}




class JSONItem: Codable
{
    //MARK: - PROPERTIES:
    
    var id: String
    var name: String
    var code: String
    var unitIssue: String
    var price: Double
    var quantity: Int
    var isFavourite: Bool
    var isPPE: Bool
    var isWaste: Bool
    var keywords: [String]
    var imageName: String
    
    
    // MARK: - INIT:
    
    
    init(id: String, name: String, code: String, unitIssue: String, price: Double, quantity: Int, isFavourite: Bool, isPPE: Bool, isWaste: Bool, keywords: Array<String>, imageName: String)
    {
        self.id = id
        self.name = name
        self.code = code
        self.unitIssue = unitIssue
        self.price = price
        self.quantity = quantity
        self.isFavourite = isFavourite
        self.isPPE = isPPE
        self.isWaste = isWaste
        self.keywords = keywords
        self.imageName = imageName
    }
    
}
