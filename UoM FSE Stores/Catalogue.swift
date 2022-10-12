//
//  Catalogue.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation




class Catalogue
{
    //MARK: - PROPERTIES:
    
    
    /// Instance to manage the catalogue.
    public let catalogueManager = CatalogueManager()
    
    
    /// All departments and their stores options.
    public var departments = Array<Department>()
    
    
    init()
    {
        let chem = catalogueManager.createChemistryCatalogue()
        guard let chemStores = chem else { fatalError("DID NOT READ THE CHEMISTRY DATABASE!") }
        var chemDept = Department(name: "Chemistry", imageName: "folder.fill", departmentCatalogue: chemStores)
        self.departments.append(chemDept)
        print("chemistry: \(chemDept.departmentCatalogue.count) categories.")
    }
    
}