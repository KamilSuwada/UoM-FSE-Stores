//
//  CatalogueVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import UIKit




class CatalogueVC: UIViewController
{
    // MARK: - UI PROPERTIES:
    
    
    // Data catalogue.
    private var catalogue: Catalogue!
    
    
    /// basketTableView to display all catalogue.
    private let catalogueTableView: UITableView =
    {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DepartmentCell.self, forCellReuseIdentifier: DepartmentCell.reuseID)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    
    // Array of the DepartmentVCs
    private var departmentVCs = Array<DepartmentVC>()
    
    
    //MARK: - DATA WRAPPERS:
    
    
    
    
    
    // MARK: - VC LIFE CYCLE:
    
    
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


// MARK: - VIEW REFRESH
extension CatalogueVC
{
    
    @objc func refreshView()
    {
        catalogueTableView.reloadData()
    }
    
}


// MARK: - SETUP:
extension CatalogueVC
{
    
    private func setup()
    {
        title = "Catalogues"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        registerForNotifications()
        setupTableView()
        setupDepartmentVCs()
    }
    
    
    private func registerForNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .dataDidChange, object: nil)
    }
    
    
    private func setupTableView()
    {
        view.addSubview(catalogueTableView)
        
        NSLayoutConstraint.activate([
            catalogueTableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            catalogueTableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: catalogueTableView.trailingAnchor, multiplier: 0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: catalogueTableView.bottomAnchor, multiplier: 0)
        ])
        
        catalogueTableView.delegate = self
        catalogueTableView.dataSource = self
    }
    
    
    private func setupDepartmentVCs()
    {
        for department in catalogue.departments
        {
            let VC = DepartmentVC(department)
            departmentVCs.append(VC)
        }
    }
    
}


// MARK: - TableView Delegate and DataSource:
extension CatalogueVC: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return catalogue.departments.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DepartmentCell.reuseID) as! DepartmentCell
        cell.prepareForReuse()
        cell.configure(with: catalogue.departments[indexPath.section].viewModel)
        cell.accessoryType = DepartmentCell.cellAccessoryType
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return DepartmentCell.rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(departmentVCs[indexPath.section], animated: true)
    }
    
}

