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
    
    
    /// Order Logic
    private let orderLogic: OrderLogic = OrderLogic()
    
    
    /// basketTableView to display all catalogue.
    private let basketTable: UITableView =
    {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    
    /// Button which clears the basket.
    private var clearBasketButton: UIBarButtonItem!
    
    
    /// Button which saves the usual order.
    private var saveUsualOrderButton: UIBarButtonItem!
    
    
    /// Button which restores the usual order.
    private var restoreUsualOrderButton: UIBarButtonItem!
    
    
    //MARK: - DATA:
    
    
    /// Dictionary of sections in table view and corresponding departments.
    private var departmentAtSection: [Int : Department] = [:]
    
    
    /// Bool indicating if all baskets are empty.
    private var allEmpty: Bool = true
    
    
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
        setupNavigationBarButtons()
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
    
    
    private func setupNavigationBarButtons()
    {
        clearBasketButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(didTapTrashButton))
        clearBasketButton.tintColor = .systemRed
        
        
        //arrow.down.to.line
        
        restoreUsualOrderButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .plain, target: self, action: #selector(didTapRestoreUsualOrder))
        restoreUsualOrderButton.tintColor = .systemBlue
        
        
        //arrow.up.to.line
        
        saveUsualOrderButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.to.line"), style: .plain, target: self, action: #selector(didTapSaveUsualOrder))
        saveUsualOrderButton.tintColor = .systemBlue
        
        
        navigationItem.leftBarButtonItems = [clearBasketButton, saveUsualOrderButton]
        navigationItem.rightBarButtonItems = [restoreUsualOrderButton]
    }
    
}


// MARK: - BarButtonItems methods:
extension BasketVC
{
    
    @objc private func didTapTrashButton(_ sender: UIBarButtonItem)
    {
        // TODO: Add alert to confirm deletion + deletion of all if no cells are selected or deletion of some if some cells are selected.
        
        orderLogic.clearBasket()
        NotificationCenter.default.post(name: .dataDidChange, object: nil)
        print("DATA DID CHANGE NOTIFICATION POSTED BY: BasketVC")
    }
    
    
    @objc private func didTapSaveUsualOrder(_ sender: UIBarButtonItem)
    {
        // TODO: Save usual order.
    }
    
    
    @objc private func didTapRestoreUsualOrder(_ sender: UIBarButtonItem)
    {
        // TODO: Restore usual order: either replace or add to current basket; ask via alert.
    }
    
}


// MARK: - UITableViewDelegate and DataSource conformance:
extension BasketVC: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var i: Int = 0
        departmentAtSection.removeAll()
        
        for department in catalogue.departments
        {
            if !orderLogic.isBasketEmpty(for: department)
            {
                departmentAtSection.updateValue(department, forKey: i)
                i += 1
            }
        }
        
        if i == 0
        {
            self.allEmpty = true
            return 1
        }
        else
        {
            self.allEmpty = false
            return i
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if allEmpty { return nil }
        let department = departmentAtSection[section]!
        let numberOfItems = orderLogic.numberOfAllItemsInBasket(for: department)
        return "\(department.name.capitalized): \(numberOfItems) items"
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if allEmpty { return nil }
        let department = departmentAtSection[section]!
        let total = orderLogic.totalInBasket(for: department)
        return "Total for \(department.name.capitalized): \(total)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if allEmpty { return 1 }
        let department = departmentAtSection[section]!
        return orderLogic.numberOfItemsInBasket(for: department)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if allEmpty
        {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Browse catalogue to add more items!"
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        else
        {
            let department = departmentAtSection[indexPath.section]!
            let cell = UITableViewCell()
            cell.textLabel?.text = orderLogic.baskets[department.name]![indexPath.row].returnFormattedSelf()
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if allEmpty { self.tabBarController?.selectedIndex = 0 }
    }
    
}


// MARK: - View refresh:
extension BasketVC
{
    
    @objc private func refreshView()
    {
        basketTable.reloadData()
    }
    
}
