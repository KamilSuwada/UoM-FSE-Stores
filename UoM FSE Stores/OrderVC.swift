//
//  OrderVC.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 26/11/2022.
//

import UIKit
import RealmSwift
import MessageUI


class OrderVC: UIViewController
{
    // MARK: - UI PROPERTIES:
    
    
    /// Realm instance.
    let realm = try! Realm()
    
    
    /// Data catalogue.
    private var catalogue: Catalogue!
    
    
    /// Logic behind orders.
    private var orderLogic: OrderLogic!
    
    
    /// Button which clears the basket.
    private var shareOrderButton: UIBarButtonItem!
    
    
    /// Button which refreshes all controllers.
    private var refreshButton: UIBarButtonItem!
    
    
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
    
    
    private let orderTextView: UITextView =
    {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "\n\n\n\n\nBrowse catalogue to add more items!\n\n\n\n\n"
        view.isEditable = false
        view.isSelectable = true
        view.font = .systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    
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


// MARK: - Setup:
extension OrderVC
{
    
    private func setup()
    {
        setupView()
        setupSegmentedControl()
        setupOrderTextView()
        registerForNotifications()
        setupNavigationBarButtons()
    }
    
    
    private func setupView()
    {
        title = "Order"
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
    
    
    private func setupOrderTextView()
    {
        view.addSubview(orderTextView)
        
        NSLayoutConstraint.activate([
            orderTextView.topAnchor.constraint(equalToSystemSpacingBelow: segmentedControlStackView.bottomAnchor, multiplier: 2),
            orderTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: orderTextView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: orderTextView.bottomAnchor, multiplier: 1)
        ])
        
        
        guard let order = orderLogic.generateOrder(for: self.activeDepartment) else { self.orderTextView.text = ""; return }
        self.orderTextView.text = order.0
    }
    
    
    private func registerForNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .dataDidChange, object: nil)
    }
    
    
    private func setupNavigationBarButtons()
    {
        shareOrderButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapShareOrderButton))
        shareOrderButton.tintColor = .systemBlue
        
        refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.2.squarepath"), style: .plain, target: self, action: #selector(didTapRefreshButton))
        refreshButton.tintColor = .systemBlue
        
        navigationItem.rightBarButtonItems = [shareOrderButton]
        navigationItem.leftBarButtonItems = [refreshButton]
    }
    
    
    @objc private func didTapRefreshButton(_ sender: UIBarButtonItem)
    {
        NotificationCenter.default.post(name: .dataDidChange, object: nil)
    }
    
    
    @objc private func didTapShareOrderButton(_ sender: UIBarButtonItem)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody(self.orderTextView.text, isHTML: false)
            mail.setSubject("Stores Order")
            present(mail, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Error!", message: "Cannot compose email! Make sure you have a mailbox set up in Mail App.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { action in
                self.dismiss(animated: true)
            }))
            
            present(alert, animated: true)
        }
    }
    
    
    @objc private func refreshView()
    {
        guard let order = orderLogic.generateOrder(for: self.activeDepartment) else { self.orderTextView.text = ""; return }
        self.orderTextView.text = order.0
    }
    
    
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
    
}


// MARK: - MFMailComposeViewControllerDelegate conformance
extension OrderVC: MFMailComposeViewControllerDelegate
{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true)
    }
    
}
