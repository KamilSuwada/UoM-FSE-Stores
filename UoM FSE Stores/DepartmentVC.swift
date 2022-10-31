//
//  DepartmentVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/10/2022.
//

import UIKit; import RealmSwift




class DepartmentVC: UIViewController
{
    // MARK: - UI PROPERTIES:
    
    
    /// Default realm.
    let realm = try! Realm()
    
    
    /// Department catalogue.
    private var department: Department!
    
    
    /// Whole FSE catalogue
    private var catalogue: Catalogue!
    
    
    /// Currently selected cell's index path.
    private var selectedIndexPath: IndexPath?
    
    
    /// View used to show number of results being found.
    private let searchResultsView: SearchResultsView =
    {
        let view = SearchResultsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    
    /// View used to change quantity of a tapped item.
    private let changeQuantityView: ChangeQuantityView =
    {
        let view = ChangeQuantityView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    
    /// Reference to the bottom layout constraint of the SearchResultsView.
    private var searchResultsViewBottomConstraint: NSLayoutConstraint?
    
    
    /// Reference to the bottom layout constraint of the ChangeQuantityView.
    private var changeQuantityViewBottomConstraint: NSLayoutConstraint?
    
    
    /// Reference to the bottom layout constraint of the DepartmentTableView.
    private var departmentTableViewBottomConstraint: NSLayoutConstraint?
    
    
    /// basketTableView to display all catalogue.
    private let departmentTableView: UITableView =
    {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
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
        searchVC.searchBar.searchTextField.tag = 1
        return searchVC
    }()
    
    
    // MARK: - STATE PROPERTIES:
    
    
    /// Items resulting from filtering by user text input.
    private var searchResults = Array<Item>()
    
    
    /// Bool indicating if the user is searching...
    private var isSearching: Bool = false
    {
        didSet
        {
            departmentTableView.reloadData()
        }
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
    
    
    convenience init(catalogue: Catalogue, department: Department)
    {
        self.init()
        self.catalogue = catalogue
        self.department = department
    }
    
}


// MARK: - VIEW REFRESH
extension DepartmentVC
{
    
    @objc func refreshView()
    {
        departmentTableView.reloadData()
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
        setupChangeQuantityView()
    }
    
    
    private func setupSearchVC()
    {
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
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
    
    
    private func hideKeyboardViews()
    {
        searchResultsViewBottomConstraint?.constant = 0
        departmentTableViewBottomConstraint?.constant = 0
        searchResultsView.alpha = 0
        changeQuantityViewBottomConstraint?.constant = 0
        changeQuantityView.alpha = 0
        view.layoutIfNeeded()
    }
    
    
    func handleKeyboard(notification: Notification)
    {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else
        {
            self.hideKeyboardViews()
            return
        }
        
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else { return }
        
        hideKeyboardViews()
        
        if let responder = UIResponder.currentFirst() as? UITextField
        {
            if responder.tag == 1
            {
                let searchResultsViewHeight = searchResultsView.bounds.height
                let keyboardHeight = keyboardFrame.cgRectValue.size.height
                UIView.animate(withDuration: 0.1, animations:{ () -> Void in
                    self.searchResultsViewBottomConstraint?.constant = -keyboardHeight + tabBarHeight
                    self.departmentTableViewBottomConstraint?.constant = -keyboardHeight + tabBarHeight - searchResultsViewHeight
                    self.searchResultsView.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
            else if responder.tag == 2
            {
                let changeQuantityViewHeight = changeQuantityView.bounds.height
                let keyboardHeight = keyboardFrame.cgRectValue.size.height
                UIView.animate(withDuration: 0.1, animations:{ () -> Void in
                    self.changeQuantityViewBottomConstraint?.constant = -keyboardHeight + tabBarHeight
                    self.departmentTableViewBottomConstraint?.constant = -keyboardHeight + tabBarHeight - changeQuantityViewHeight
                    self.changeQuantityView.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
            else { fatalError("Unknown responder made the keyboard rise!") }
        }
        
        
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
        
        searchResultsView.delegate = self
    }
    
    
    private func setupChangeQuantityView()
    {
        view.addSubview(changeQuantityView)
        
        changeQuantityViewBottomConstraint = changeQuantityView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        changeQuantityViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            changeQuantityView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: changeQuantityView.trailingAnchor, multiplier: 0),
            changeQuantityView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        changeQuantityView.delegate = self
    }
    
}


// MARK: - SearchResultsViewDelegate conformance
extension DepartmentVC: SearchResultsViewDelegate, ChangeQuantityViewDelegate
{
    
    func didResign(at indexPath: IndexPath)
    {
        departmentTableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = nil
    }
    
    
    func dataOfItemDidChange(at indexPath: IndexPath)
    {
        departmentTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    func switchDidChangeValue(to newValue: Bool)
    {
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: "SearchAllDepartments")
        updateSearchResults(for: searchController)
    }
    
}


// MARK: - SearchBar Delegate:
extension DepartmentVC: UISearchResultsUpdating, UISearchControllerDelegate
{
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        hideKeyboardViews()
        searchResultsView.resignFirstResponder()
        changeQuantityView.resign()
    }
    
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let searchText = searchController.searchBar.text, searchText != "" else { searchResultsView.setTextOnFoundLabel(" "); isSearching = false; return }
        
        
        if UserDefaults.standard.bool(forKey: "SearchAllDepartments")
        {
            searchResults = catalogue.allItems.filter
            { (item: Item) -> Bool in
                return item.name.lowercased().contains(searchText.lowercased()) || item.code.lowercased().contains(searchText.lowercased()) || item.keywords.joined().lowercased().contains(searchText.lowercased())
            }
        }
        else
        {
            searchResults = department.allItems.filter
            { (item: Item) -> Bool in
                return item.name.lowercased().contains(searchText.lowercased()) || item.code.lowercased().contains(searchText.lowercased()) || item.keywords.joined().lowercased().contains(searchText.lowercased())
            }
        }
        
        let resultsFound = String(searchResults.count)
        var foundString = "Found: "
        for _ in 0..<(4 - resultsFound.count) { foundString += " " }
        foundString += resultsFound
        
        searchResultsView.setTextOnFoundLabel(foundString)
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
            return 1 // In future, show other stores in a separate sections too if UserDefaults.standard.bool(forKey: "SearchAllDepartments") is true...
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
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            cell.prepareForReuse()
            let item = searchResults[indexPath.row]
            cell.configure(with: item, at: indexPath)
            cell.delegate = self
            return cell
        }
        else
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
                cell.prepareForReuse()
                cell.configure(with: department.departmentCatalogue[indexPath.section].name)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
                cell.prepareForReuse()
                let item = department.departmentCatalogue[indexPath.section].items[indexPath.row - 1]
                cell.configure(with: item, at: indexPath)
                cell.delegate = self
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isSearching
        {
            if selectedIndexPath == indexPath
            {
                tableView.deselectRow(at: indexPath, animated: true)
                searchController.isActive = false
                changeQuantityView.resign()
                selectedIndexPath = nil
            }
            else
            {
                selectedIndexPath = indexPath
                let tappedItem = searchResults[indexPath.row]
                changeQuantityView.configureView(for: tappedItem, at: indexPath, with: true)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        else
        {
            if indexPath.row == 0
            {
                tableView.deselectRow(at: indexPath, animated: true)
                do { try realm.write { department.didTapOnSection(indexPath.section) } }
                catch { print(error.localizedDescription) }
                tableView.reloadSections([indexPath.section], with: .fade)
            }
            else
            {
                if selectedIndexPath == indexPath
                {
                    tableView.deselectRow(at: indexPath, animated: true)
                    changeQuantityView.resign()
                    selectedIndexPath = nil
                }
                else
                {
                    selectedIndexPath = indexPath
                    let tappedItem = department.departmentCatalogue[indexPath.section].items[indexPath.row - 1]
                    changeQuantityView.configureView(for: tappedItem, at: indexPath)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if isSearching
        {
            return ItemCell.rowHeight
        }
        else
        {
            if indexPath.row == 0 { return CategoryCell.rowHeight }
            else { return ItemCell.rowHeight }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if !isSearching { return "No. of items: \(department.departmentCatalogue[section].items.count)" }
        else { return " " }
    }
    
}


// MARK: - ItemCellDelegate conformance:
extension DepartmentVC: ItemCellDelegate
{
    
    func didTapPlusOne(for item: Item, at indexPath: IndexPath?)
    {
        guard let indexPath = indexPath else { fatalError("IndexPath should never be nil!") }
        do { try realm.write { item.didTapPlusOne() }; notifyDataDidChange() }
        catch { print(error.localizedDescription) }
        departmentTableView.reloadRows(at: [indexPath], with: .fade)
        if let path = selectedIndexPath { departmentTableView.selectRow(at: path, animated: true, scrollPosition: .none) }
        if changeQuantityView.isHidden == false { changeQuantityView.configureView(for: item, at: indexPath, with: false) }
    }
    
    
    func didTapMinusOne(for item: Item, at indexPath: IndexPath?)
    {
        guard let indexPath = indexPath else { fatalError("IndexPath should never be nil!") }
        if item.willTapMinusOne()
        {
            do { try realm.write { item.didTapMinusOne() }; notifyDataDidChange() }
            catch { print(error.localizedDescription) }
            departmentTableView.reloadRows(at: [indexPath], with: .fade)
        }
        if let path = selectedIndexPath { departmentTableView.selectRow(at: path, animated: true, scrollPosition: .none) }
        if changeQuantityView.isHidden == false { changeQuantityView.configureView(for: item, at: indexPath, with: false) }
    }
    
    
    func didTapFavourite(for item: Item, at indexPath: IndexPath?)
    {
        guard let indexPath = indexPath else { fatalError("IndexPath should never be nil!") }
        do { try realm.write { item.didTapFavourite() } }
        catch { print(error.localizedDescription) }
        departmentTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    private func notifyDataDidChange()
    {
        NotificationCenter.default.post(name: .dataDidChange, object: nil)
        print("DATA DID CHANGE NOTIFICATION POSTED BY: DepartmentVC")
    }
    
}
