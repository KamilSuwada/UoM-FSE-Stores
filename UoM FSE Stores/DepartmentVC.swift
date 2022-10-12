//
//  DepartmentVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/10/2022.
//

import UIKit




class DepartmentVC: UIViewController
{
    // MARK: - UI PROPERTIES:
    
    
    // Data catalogue.
    private var department: Department!
    
    
    
    // View used to show number of results being found.
    private let searchResultsView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPurple
        view.alpha = 0
        return view
    }()
    
    
    // Reference to the bottom layout constraint of the SearchResultsView.
    private var searchResultsViewBottomConstraint: NSLayoutConstraint?
    
    
    // Reference to the bottom layout constraint of the DepartmentTableView.
    private var departmentTableViewBottomConstraint: NSLayoutConstraint?
    
    
    /// basketTableView to display all catalogue.
    private let departmentTableView: UITableView =
    {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.register(DepartmentCell.self, forCellReuseIdentifier: DepartmentCell.reuseID)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    
    /// SearchBar to filter items based on their titles and content.
    private let searchController: UISearchController =
    {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.view.translatesAutoresizingMaskIntoConstraints = false
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search for..."
        return searchVC
    }()
    
    
    // MARK: - STATE PROPERTIES:
    
    
    // Items resulting from filtering by user text input.
    private var searchResults = Array<Item>()
    
    
    // Bool indicating if the user is searching...
    private var isSearching: Bool = false
    {
        didSet { departmentTableView.reloadData() }
    }
    
    
    //MARK: - DATA WRAPPERS:
    
    
    private var basket: Array<String>
    {
        get { return Array<String>() }
    }
    
    
    // MARK: - VC LIFE CYCLE:
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    
    // MARK: - INIT:
    
    
    convenience init(_ department: Department)
    {
        self.init()
        self.department = department
    }
    
}


// MARK: - VIEW REFRESH
extension DepartmentVC
{
    
    @objc func refreshView()
    {
        
    }
    
}


// MARK: - SETUP:
extension DepartmentVC
{
    
    private func setup()
    {
        title = department.name
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupSearchVC()
        registerForNotifications()
        setupTableView()
        setupSearchResultsView()
    }
    
    
    private func setupSearchVC()
    {
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
    }
    
    
    private func registerForNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .dataDidChange, object: nil)
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main)
        { notification in
            self.handleKeyboard(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
        { (notification) in
            self.handleKeyboard(notification: notification)
        }
    }
    
    
    func handleKeyboard(notification: Notification) {
        // 1
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else
        {
            searchResultsViewBottomConstraint?.constant = 0
            departmentTableViewBottomConstraint?.constant = 0
            searchResultsView.alpha = 0
            view.layoutIfNeeded()
            return
        }
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else { return }
        let searchResultsViewHeight = searchResultsView.bounds.height
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            self.searchResultsViewBottomConstraint?.constant = -keyboardHeight + tabBarHeight
            self.departmentTableViewBottomConstraint?.constant = -keyboardHeight + tabBarHeight - searchResultsViewHeight
            self.searchResultsView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    
    private func setupTableView()
    {
        view.addSubview(departmentTableView)
        
        departmentTableViewBottomConstraint = departmentTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        departmentTableViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            departmentTableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            departmentTableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: departmentTableView.trailingAnchor, multiplier: 0)
        ])
        
        departmentTableView.delegate = self
        departmentTableView.dataSource = self
    }
    
    
    private func setupSearchResultsView()
    {
        view.addSubview(searchResultsView)
        
        searchResultsViewBottomConstraint = searchResultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        searchResultsViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            searchResultsView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchResultsView.trailingAnchor, multiplier: 0),
            searchResultsView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}


// MARK: - SearchBar Delegate:
extension DepartmentVC: UISearchResultsUpdating
{
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let searchText = searchController.searchBar.text, searchText != "" else { isSearching = false; return }
        
        searchResults = department.allItems.filter
        { (item: Item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased()) || item.code.lowercased().contains(searchText.lowercased()) || item.keywords.joined().lowercased().contains(searchText.lowercased())
        }
        
        isSearching = true
    }
    
}


// MARK: - TableView Delegate and DataSource:
extension DepartmentVC: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if isSearching
        {
            return 1 // In future, show other stores in a separate sections too...
        }
        else
        {
            return department.departmentCatalogue.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearching
        {
            return searchResults.count
        }
        else
        {
            if department.departmentCatalogue[section].isOpened == false { return 1 }
            else { return department.departmentCatalogue[section].items.count + 1 }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isSearching
        {
            let cell = UITableViewCell()
            cell.textLabel?.text = searchResults[indexPath.row].name
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        else
        {
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            if indexPath.row == 0 { cell.textLabel?.text = department.departmentCatalogue[indexPath.section].name }
            else { cell.textLabel?.text = department.departmentCatalogue[indexPath.section].items[indexPath.row - 1].name }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearching
        {
            // Extraction of the selected item and setting it displayed as full cell...
            
            
            
            searchController.isActive = false           // Stopping the search and resigning the delegate.
        }
        else
        {
            if indexPath.row == 0
            {
                department.didTapOnSection(indexPath.section)
                tableView.reloadSections([indexPath.section], with: .fade)
            }
        }
    }
    
}
