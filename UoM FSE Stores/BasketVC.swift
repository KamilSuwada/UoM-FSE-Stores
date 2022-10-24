//
//  BasketVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/10/2022.
//

import UIKit; import RealmSwift




class BasketVC: UIViewController
{
    // MARK: - UI PROPERTIES:
    
    
    /// Realm instance.
    let realm = try! Realm()
    
    
    /// Data catalogue.
    private var catalogue: Catalogue!
    
    
    /// basketTableView to display all catalogue.
    private let basketTable: UITableView =
    {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    
    //MARK: - DATA WRAPPERS:
    
    
    private var basket: Array<String>
    {
        get { return Array<String>() } // temp...
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


// MARK: - SETUP:
extension BasketVC
{
    
    private func setup()
    {
        setupView()
        registerForNotifications()
        setupTableView()
    }
    
    
    private func setupView()
    {
        title = "Basket"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func registerForNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .dataDidChange, object: nil)
    }
    
    
    private func setupTableView()
    {
        basketTable.delegate = self
        basketTable.dataSource = self
        view.addSubview(basketTable)
        
        NSLayoutConstraint.activate([
            basketTable.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            basketTable.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: basketTable.trailingAnchor, multiplier: 0),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: basketTable.bottomAnchor, multiplier: 0)
        ])
    }
    
}


// MARK: - UITableViewDelegate and DataSource conformance:
extension BasketVC: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Section \(section) title."
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return "Section \(section) footer."
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Section \(indexPath.section)     Row: \(indexPath.row)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - View refresh:
extension BasketVC
{
    
    @objc private func refreshView()
    {
        basketTable.reloadData()
        basketTable.backgroundColor = .red
    }
    
}
