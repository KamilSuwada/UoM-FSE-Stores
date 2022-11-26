//
//  OrderLogic.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 24/10/2022.
//

import Foundation; import RealmSwift




class OrderLogic
{
// MARK: - Properties:
    
    
    /// Instance of the realm.
    let realm = try! Realm()
    
    
    /// Array of past orders for all departments. Filer further to get per department.
    var pastOrders: Results<PastOrder> { return realm.objects(PastOrder.self) }
    
    
    /// Holds a reference to all items in basket for a given department. Updated every time self.currentBasket(for department) is called.
    var baskets: [String : Array<Item>] = [:]
    
    
// MARK: - Basket discovery methods:
    
    
    /// Method tells if a basket in a given department is empty.
    public func isBasketEmpty(for department: Department) -> Bool
    {
        for item in department.allItems
        {
            if item.quantity > 0 { return false }
        }
        
        return true
    }
    
    
    /// Method returns number of items (all) in basket for a given department.
    public func numberOfAllItemsInBasket(for department: Department) -> Int
    {
        var count: Int = 0
        
        for item in department.allItems
        {
            if item.quantity > 0 { count += item.quantity }
        }
        
        return count
    }
    
    
    /// Method returns number of items (kinds) in basket for a given department.
    public func numberOfItemsInBasket(for department: Department) -> Int
    {
        var count: Int = 0
        
        for item in department.allItems
        {
            if item.quantity > 0 { count += 1 }
        }
        
        return count
    }
    
    
    /// Method returns total in basket for a given department.
    public func totalInBasket(for department: Department) -> String
    {
        var total: Double = 0.0
        
        for item in self.currentBasket(for: department)
        {
            total += item.price * Double(item.quantity)
        }
        
        return String(format: "£%.2f", total)
    }
    
    
    /// Function clears basket.
    public func clearBasket(for department: Department)
    {
        do
        {
            try realm.write({
                for item in department.allItems
                {
                    if item.quantity > 0 { item.quantity = 0 }
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
}


// MARK: - Generation of orders:
extension OrderLogic
{
    
    /// Returns items in basket for department.
    public func currentBasket(for department: Department) -> Array<Item>
    {
        var output = Array<Item>()
        
        for item in department.allItems
        {
            if item.quantity > 0
            {
                output.append(item)
            }
        }
        
        self.baskets.updateValue(output, forKey: department.name)
        return output
    }
    
    
    /// Method updates usual order for department.
    public func updateUsualOrder(for department: Department) -> Bool
    {
        let basket = currentBasket(for: department)
        
        do
        {
            try realm.write({
                for item in department.allItems
                {
                    if item.isUsual
                    {
                        item.makeUsual(false)
                    }
                }
                
                for item in basket
                {
                    item.makeUsual(true)
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    
    /// Method restores usual order for department.
    public func restoreUsualOrder(for department: Department, add: Bool = false) -> Bool
    {
        if add == false
        {
            self.clearBasket(for: department)
        }
        
        do
        {
            try realm.write({
                for item in department.allItems
                {
                    if item.isUsual
                    {
                        item.quantity += item.usualQuantity
                    }
                }
            })
        }
        catch
        {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    
    /// Method generates order for a department.
    public func generateOrder(for department: Department) -> (String, String)?
    {
        guard let name = User.name, User.name != "" else { return nil }
        guard let lab = User.lab, User.lab != "" else { return nil }
        guard let primaryChargeAccount = User.primaryChargeAccount, User.primaryChargeAccount != "" else { return nil }
        guard let aaCode = User.aaCode, User.aaCode != "" else { return nil }
        
        var ppeItem: Int = 0
        var orderList: String = "\(primaryChargeAccount)\n"
        var orderString = """
Dear \(department.name.capitalized) Stores,

It is \(name) from the \(lab).

I would like to place an order for the following items for which, I would like to use code: \(primaryChargeAccount):



"""
        
        for item in self.currentBasket(for: department)
        {
            if item.isPPE == false
            {
                let line = "\(item.quantity)x \(item.name) : \(item.code)\n"
                orderString = orderString + line
                orderList = orderList + line
            }
            else
            {
                ppeItem += 1
            }
        }
        
        if ppeItem != 0
        {
            orderString += "\n\nAdditionally, we would like to add the following PPE items to the order using code: \(aaCode):\n\n"
            orderList += "\n\n\(primaryChargeAccount)\n"
            
            for item in self.currentBasket(for: department)
            {
                if item.isPPE == true
                {
                    let line = "\(item.quantity)x \(item.name) : \(item.code)\n"
                    orderString = orderString + line
                    orderList = orderList + line
                }
            }
            
            orderString = orderString + "\n\n"
        }
        else
        {
            orderString = orderString + "\n\n"
        }
        
        let endingString = """
Thank you for any help with this,

Kind Regards

\(name)
"""
        
        orderString = orderString + endingString
        
        return (orderString, orderList)
    }
    
}
