//
//  Catalogue.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation; import RealmSwift




class Catalogue
{
    //MARK: - PROPERTIES:
    
    
    /// Instance to manage the catalogue.
    public let catalogueManager = CatalogueManager()
    
    
    /// All departments and their stores options.
    public var departments = List<Department>()
    
    
    init()
    {
        
        // Chemistry:
        if let chemDept = catalogueManager.chemistryDepartment
        {
            self.departments.append(chemDept)
        }
        else
        {
            let chem = catalogueManager.createChemistryCatalogue()
            guard let chemStores = chem else { fatalError("DID NOT READ THE CHEMISTRY DATABASE!") }
            let chemDept = Department(name: "Chemistry", imageName: "folder.fill", departmentCatalogue: chemStores, store: .chemistry)
            catalogueManager.writeDepartment(chemDept)
            self.departments.append(chemDept)
        }
        
        
        
        
        // Physics:
        
        
        
        // MIB:
        
    }
    
    
    public var allItems: Array<Item>
    {
        var output = Array<Item>()
        for department in departments { output.append(contentsOf: department.allItems) }
        return output
    }
    
}
