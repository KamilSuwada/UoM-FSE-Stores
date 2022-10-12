//
//  Item.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation




struct Item: Codable
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
    
    
    //MARK: - METHODS:
    
    
    // computed property which returns quantity of the item as e.g. x 4
    public var formattedQuantity: String
    {
        return "x \(self.quantity)"
    }
    
    
    // formatted price returns quantity * price of the selection as e.g. 12.53
    public var formattedPrice: String
    {
        let amount = self.price * Double(self.quantity)
        return String(format: "%.2f", amount)
    }
    
    
    // formatted list price returns price of the selection as e.g. 12.53
    public var formattedListPrice: String
    {
        return String(format: "%.2f", self.price)
    }
    
    
    // method for gneration of a short name: ful name is split into an array by the space character set, then first 4 words are rejoined.
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
    
    
    // method for increasing quantity by 1.
    public mutating func didTapPlusOne()
    {
        self.quantity += 1
    }
    
    
    // method for decreasing the quantity by 1. Only called when quantity is greater than zero: we will not order -1 bottles of DCM.
    public mutating func didTapMinusOne()
    {
        if (self.quantity > 0)
        {
            self.quantity -= 1
        }
    }
    
    
    // method for toggling the selection of an item as favourite.
    public mutating func didTapFavourite()
    {
        self.isFavourite.toggle()
    }
    
    
    // method for setting the quantity manually.
    public mutating func changeQuantity(to number: Int)
    {
        guard number >= 0 else { return }
        self.quantity = number
    }
    
    
    
    // method for expressing the item as one line, for order.
    public func returnFormattedSelf() -> String
    {
        return "\(self.quantity) x \(self.name) - \(self.code)\n"
    }
    
}


