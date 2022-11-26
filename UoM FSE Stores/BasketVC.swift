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
    private var orderLogic: OrderLogic!
    
    
    /// Segmented control.
    private var segmentedControl: UISegmentedControl!
    
    
    /// Array of department names.
    private var departmentNames: Array<String>
    {
        var output = Array<String>()
        
        for department in self.catalogue.departments
        {
            output.append(department.name)
        }
        
        return output
    }
    
    
    /// Reference to an active department from the segmented control.
    private var activeDepartment: Department!
    {
        didSet
        {
            refreshView()
        }
    }
    
    
    /// Stack view to house segmented control.
    private let segmentedControlStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.backgroundColor = .clear
        return stack
    }()
    
    
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
    //private var allEmpty: Bool = true
    
    
    //MARK: - VC LIFE CYCLE:
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    
    // MARK: - INIT:
    
    
    convenience init(catalogue: Catalogue, orderLogic: OrderLogic)
    {
        self.init()
        self.catalogue = catalogue
        self.orderLogic = orderLogic
    }
    
}


// MARK: - SETUP:
extension BasketVC
{
    
    private func setup()
    {
        setupView()
        setupSegmentedControl()
        registerForNotifications()
        setupTableView()
        setupNavigationBarButtons()
    }
    
    
    private func setupView()
    {
        title = "Basket"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func setupSegmentedControl()
    {
        segmentedControl = UISegmentedControl(items: departmentNames)
        segmentedControl.selectedSegmentIndex = 0
        activeDepartment = catalogue.departments[0]
        segmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged), for: .valueChanged)
        
        view.addSubview(segmentedControlStackView)
        segmentedControlStackView.addArrangedSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControlStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            segmentedControlStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: segmentedControlStackView.trailingAnchor, multiplier: 1),
        ])
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
            basketTable.topAnchor.constraint(equalToSystemSpacingBelow: segmentedControlStackView.bottomAnchor, multiplier: 1),
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
        
        
        navigationItem.leftBarButtonItems = [clearBasketButton]
        navigationItem.rightBarButtonItems = [saveUsualOrderButton, restoreUsualOrderButton]
    }
    
}


// MARK: - BarButtonItems methods:
extension BasketVC
{
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl)
    {
        let deptName = departmentNames[sender.selectedSegmentIndex]
        
        for department in self.catalogue.departments
        {
            if department.name == deptName
            {
                self.activeDepartment = department
            }
        }
    }
    
    
    @objc private func didTapTrashButton(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Delete Basket", message: "All items will be removed from your basket in \(self.activeDepartment.name). This does not affect the state of your usual order nor baskets in other departments.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler:
        { (action: UIAlertAction!) in
            self.orderLogic.clearBasket(for: self.activeDepartment)
            NotificationCenter.default.post(name: .dataDidChange, object: nil)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
        { (action: UIAlertAction!) in
            return
        }))

        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func didTapSaveUsualOrder(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Override Usual Order", message: "You are going to set your usual order as current basket in \(self.activeDepartment.name).", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler:
        { (action: UIAlertAction!) in
            if self.orderLogic.updateUsualOrder(for: self.activeDepartment)
            {
                print("Usual order updated.")
            }
            else
            {
                print("ERROR while updating usual order!")
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
        { (action: UIAlertAction!) in
            return
        }))

        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func didTapRestoreUsualOrder(_ sender: UIBarButtonItem)
    {
        if orderLogic.isBasketEmpty(for: activeDepartment)
        {
            if self.orderLogic.restoreUsualOrder(for: self.activeDepartment, add: true)
            {
                NotificationCenter.default.post(name: .dataDidChange, object: nil)
            }
            else
            {
                print("ERROR while restoring usual order!")
            }
        }
        else
        {
            let alert = UIAlertController(title: "Items in Basket", message: "Would you like to override basket content or add usual on top of it for \(self.activeDepartment.name)?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Override", style: .destructive, handler:
            { (action: UIAlertAction!) in
                if self.orderLogic.restoreUsualOrder(for: self.activeDepartment)
                {
                    NotificationCenter.default.post(name: .dataDidChange, object: nil)
                }
                else
                {
                    print("ERROR while restoring usual order!")
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler:
            { (action: UIAlertAction!) in
                if self.orderLogic.restoreUsualOrder(for: self.activeDepartment, add: true)
                {
                    NotificationCenter.default.post(name: .dataDidChange, object: nil)
                }
                else
                {
                    print("ERROR while restoring usual order!")
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            { (action: UIAlertAction!) in
                return
            }))

            present(alert, animated: true, completion: nil)
        }
    }
    
}


// MARK: - UITableViewDelegate and DataSource conformance:
extension BasketVC: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let numberOfItems = orderLogic.numberOfAllItemsInBasket(for: activeDepartment)
        if numberOfItems == 0 { return nil }
        return "\(numberOfItems) items in basket"
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        let numberOfItems = orderLogic.numberOfAllItemsInBasket(for: activeDepartment)
        if numberOfItems == 0 { return nil }
        let total = orderLogic.totalInBasket(for: activeDepartment)
        return "Total: \(total)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let numberOfItems = orderLogic.numberOfAllItemsInBasket(for: activeDepartment)
        if numberOfItems == 0 { return 1 }
        return orderLogic.numberOfItemsInBasket(for: activeDepartment)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let numberOfItems = orderLogic.numberOfAllItemsInBasket(for: activeDepartment)
        if numberOfItems == 0
        {
            let cell = UITableViewCell()
            cell.textLabel?.text = "\n\n\n\n\nBrowse catalogue to add more items!\n\n\n\n\n"
            cell.textLabel?.numberOfLines = 0
            cell.contentView.backgroundColor = .secondarySystemBackground
            return cell
        }
        else
        {
            let cell = UITableViewCell()
            cell.textLabel?.text = orderLogic.baskets[activeDepartment.name]![indexPath.row].returnFormattedSelf()
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let numberOfItems = orderLogic.numberOfAllItemsInBasket(for: activeDepartment)
        if numberOfItems == 0 { self.tabBarController?.selectedIndex = 0 }
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
