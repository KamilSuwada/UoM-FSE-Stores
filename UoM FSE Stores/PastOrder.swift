//
//  Order.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 24/10/2022.
//

import UIKit; import RealmSwift




class PastOrder: Object
{
// MARK: - INIT:
    
    
    convenience init(for department: Department.StoreType, items: Array<Item>, using primaryAccount: String, aaCode: String)
    {
        self.init()
        self.orderDepartment = department
        self.primaryChargeAccount = primaryAccount
        self.aaCodeUsed = aaCode
        self.dateAndTimePlaced = Date()
        
        for item in items
        {
            let data = ItemData(name: item.name, code: item.code, price: item.price, quantity: item.quantity)
            self.itemsOrdered.updateValue(data, forKey: item.id)
        }
    }
    
    
// MARK: - Properties:
    
    
    /// ID of the order.
    @objc dynamic var orderID: String = UUID().uuidString
    
    
    /// Department in which the order was placed. At this point, FSE does not allow ordering from multiple departments in one order.
    var orderDepartment: Department.StoreType = .None
    
    
    /// Date and time of when the order was generated.
    @objc dynamic var dateAndTimePlaced: Date = Date()
    
    
    /// Relevant information about the items that will be stored and allow for order restoring.
    struct ItemData: Codable
    {
        let name: String
        let code: String
        let price: Double
        let quantity: Int
    }
    
    
    /// Dictionary of the item id and its data. Order can be restored from id numbers and data.
    var itemsOrdered: [String : ItemData] = [ : ]
    
    
    /// Primary charge account used.
    @objc dynamic var primaryChargeAccount: String = ""
    
    
    /// AA Code used for the order. Can be oprional, as not all orders will include items which can be charged on the AA code.
    @objc dynamic var aaCodeUsed: String = ""
    
}


// MARK: Restoring the order:
extension PastOrder
{
    
    enum OrderRestoreOutcome
    {
        case success
        case unrecognisedItemsFound
        case failed
    }
    
    
    struct OrderRestoreData
    {
        let message: String
        let unrecognisedItems: Array<ItemData>?
    }
    
    
    /// Method intended on restoring the order to the current basket.
    public func restoreThisOrder(for department: Department, overrideQuantities: Bool = true) -> (OrderRestoreOutcome, OrderRestoreData?)
    {
        let realm = try! Realm()
        var outcome: OrderRestoreOutcome = .success
        var unrecognisedItems = Array<ItemData>()
        var errorMessage = "Found items which are no longer in the main database! They might no longer be available in \(department.name) stores."
        
        do
        {
            try realm.write {
                for (key, value) in self.itemsOrdered
                {
                    var foundItem = false
                    
                    for item in department.allItems
                    {
                        if item.id == key
                        {
                            foundItem = true
                            if overrideQuantities { item.quantity = value.quantity }
                            else { item.quantity += value.quantity }
                        }
                    }
                    
                    if !foundItem
                    {
                        outcome = .unrecognisedItemsFound
                        unrecognisedItems.append(value)
                    }
                }
            }
        }
        catch
        {
            errorMessage = error.localizedDescription
        }
        
        
        switch outcome
        {
        case .success:
            return (outcome, nil)
        case .unrecognisedItemsFound:
            return (outcome, OrderRestoreData(message: errorMessage, unrecognisedItems: unrecognisedItems))
        case .failed:
            return (outcome, OrderRestoreData(message: errorMessage, unrecognisedItems: unrecognisedItems))
        }
    }
    
}
