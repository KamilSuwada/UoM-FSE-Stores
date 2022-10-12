//
//  CatalogueManager.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import Foundation




struct CatalogueManager
{
    //MARK: - PROPERTIES:
    
    
    func createChemistryCatalogue() -> Array<Category>?
    {
        let decoder = JSONDecoder()
        let url = Bundle.main.url(forResource: "Chem_Database", withExtension: "json")
        guard let url = url else { fatalError("NO DATABASE!") }
        
        do
        {
            let data = try Data(contentsOf: url)
            let categories = try decoder.decode(Array<Category>.self, from: data)
            return categories
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
}
