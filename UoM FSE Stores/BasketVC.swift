//
//  BasketVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import UIKit




class BasketVC: UIViewController
{
    // MARK: - UI PROPERTIES:
    
    
    // Data catalogue.
    private var catalogue: Catalogue!
    
    
    /// basketTableView to display all catalogue.
    private let basketTable: UITableView =
    {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.register(GuideCell.self, forCellReuseIdentifier: GuideCell.reuseID)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    // MARK: - STATE PROPERTIES:
    
    
    private var isSearching: Bool = false
    private var selectedCells = Array<Int>()
    
    
    //MARK: - DATA WRAPPERS:
    
    
    private var basket: Array<String>
    {
        get { return Array<String>() }
    }
    
    
    //MARK: - VC LIFE CYCLE:
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    
    // MARK: - INIT:
    
    
    convenience init(_ catalogue: Catalogue)
    {
        self.init()
        self.catalogue = catalogue
    }
    
}




// MARK: SETUP:
extension BasketVC
{
    
    private func setup()
    {
        
    }
    
}
