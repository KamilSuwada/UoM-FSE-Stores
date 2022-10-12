//
//  Department.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/10/2022.
//

import UIKit




struct Department
{
    // MARK: - PROPERTIES:
    
    
    let name: String
    
    
    let imageName: String
    
    
    var departmentCatalogue: Array<Category>
    
    
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
    
    
    public mutating func didTapOnSection(_ section: Int)
    {
        self.departmentCatalogue[section].didTapOnCategory()
    }
}
