//
//  Department.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/10/2022.
//

import UIKit; import RealmSwift




class Department: Object
{
// MARK: - PROPERTIES:
    
    
    @objc dynamic var name: String = ""
    
    
    @objc dynamic var imageName: String = ""
    
    
    var departmentCatalogue: List<Category> = List<Category>()
    
    
    @objc dynamic var storeType: String = ""
    
    
    enum StoreType: String
    {
        case chemistry = "chemistry"
        case physics = "physics"
        case MIB = "MIB"
        case None = "NONE"
    }
    
    
// MARK: - INIT:
    
    
    convenience init(name: String, imageName: String, departmentCatalogue: Array<JSONCategory>, store type: StoreType)
    {
        self.init()
        self.name = name
        self.imageName = imageName
        self.storeType = type.rawValue
        let deptCatList = List<Category>()
        for category in departmentCatalogue
        {
            let realmCategory = Category(from: category)
            deptCatList.append(realmCategory)
        }
        self.departmentCatalogue = deptCatList
        print("INIT WAS CALLED")
    }
    
    
    // MARK: - COMPUTED PROPERTIES:
    
    
    public var image: UIImage
    {
        return UIImage(systemName: imageName)!
    }
    
    
    public var viewModel: DepartmentCell.ViewModel
    {
        return DepartmentCell.ViewModel(departmentName: name, departmentImage: image)
    }
    
    
    public var allItems: Array<Item>
    {
        var output = Array<Item>()
        
        for category in departmentCatalogue
        {
            output.append(contentsOf: category.items)
        }
        
        return output
    }
    
    
    // MARK: - METHODS:
    
    
    public func didTapOnSection(_ section: Int)
    {
        self.departmentCatalogue[section].didTapOnCategory()
    }
}
