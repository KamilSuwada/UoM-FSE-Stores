//
//  CatalogueManager.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation; import RealmSwift




struct CatalogueManager
{
// MARK: - PROPERTIES:
    
    
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    
// MARK: - Realm:
    
    
    // CREATE:
    
    
    public func writeDepartment(_ department: Department)
    {
        do
        {
            try realm.write
            {
                realm.add(department)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    
    // READ:
    
    
    public var chemistryDepartment: Department?
    {
        let results = realm.objects(Department.self)
        for result in results
        {
            if result.storeType == "chemistry" { return result }
        }
        return nil
    }
    
    
    
// MARK: - Catalogues generation:
    
    
    func createChemistryCatalogue() -> Array<JSONCategory>?
    {
        let decoder = JSONDecoder()
        let url = Bundle.main.url(forResource: "Chem_Database", withExtension: "json")
        guard let url = url else { fatalError("NO DATABASE!") }
        
        do
        {
            let data = try Data(contentsOf: url)
            let categories = try decoder.decode(Array<JSONCategory>.self, from: data)
            return categories
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
}
