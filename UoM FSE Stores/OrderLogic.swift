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
    
}


// MARK: - Generation of orders:
extension OrderLogic
{
    
    private func currentBasket(for department: Department) -> Array<Item>
    {
        var output = Array<Item>()
        
        for item in department.allItems
        {
            if item.quantity > 0
            {
                output.append(item)
            }
        }
        
        return output
    }
    
    
    public func generateOrder(for department: Department) -> (String, String)
    {
        var ppeItem: Int = 0
        var orderList: String = ""
        var orderString = """
Dear \(department.name.capitalized) Stores,

It is \(User.name) from the \(User.lab).

I would like to place an order for the following items for which, I would like to use code: \(User.primaryChargeAccount):



"""
        
        for item in self.currentBasket(for: department)
        {
            if item.isPPE == false
            {
                let line = "\(item.quantity)x \(item.name) - \(item.code)\n"
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
            orderString = orderString + "\n\n"
            orderString = orderString + "Additionally, we would like to add the following PPE items to the order using code: \(User.aaCode):"
            
            orderString = orderString + "\n\n"
            
            for item in self.currentBasket(for: department)
            {
                if item.isPPE == true
                {
                    let line = "\(item.quantity)x \(item.name) - \(item.code)\n"
                    orderString = orderString + line
                    orderList = orderList + line
                }
                else
                {
                    ppeItem += 1
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

\(User.name)
"""
        
        orderString = orderString + endingString
        
        return (orderString, orderList)
    }
    
}
