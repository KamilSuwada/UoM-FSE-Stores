//
//  SearchResultsView.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 16/10/2022.
//

import UIKit


protocol SearchResultsViewDelegate: AnyObject
{
    func switchDidChangeValue(to newValue: Bool)
}


class SearchResultsView: AboveKeyboardView
{
    //MARK: - Properties:
    
    
    /// Style of the users interface.
    private var appearance: UIUserInterfaceStyle?
    
    
    /// Delegate of the bubble view.
    weak var delegate: SearchResultsViewDelegate?
    
    
    /// Main stack view holds all current week components for this view.
    private let mainStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.backgroundColor = .clear
        return stack
    }()
    
    
    /// Number of found items label.
    private let itemsFoundLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Found: XXXX"
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return label
    }()
    
    
    /// Label of the day number.
    private let otherStoresLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Search all FSE:"
        return label
    }()
    
    
    /// Toggle switch to decide if should show all FSE items.
    private let toggleSwitch: UISwitch =
    {
        let toggle = UISwitch(frame: .zero)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        let defaults = UserDefaults.standard
        toggle.isOn = defaults.bool(forKey: "SearchAllDepartments")
        return toggle
    }()
    
    
// MARK: - Setup:
    
    
    override func setup()
    {
        super.setup()
        setupView()
        setupResultsLabel()
        setupMainStackView()
        setupLabels()
        setupToggleSwitch()
    }

}




// MARK: - Setup methods:
extension SearchResultsView
{
    
    private func setupView()
    {
        backgroundColor = .systemPurple
    }
    
    
    private func setupResultsLabel()
    {
        addSubview(itemsFoundLabel)
        
        NSLayoutConstraint.activate([
            itemsFoundLabel.topAnchor.constraint(equalTo: topAnchor),
            itemsFoundLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            itemsFoundLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    private func setupMainStackView()
    {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: itemsFoundLabel.trailingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.trailingAnchor, multiplier: 3),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    private func setupLabels()
    {
        mainStackView.addArrangedSubview(otherStoresLabel)
    }
    
    
    private func setupToggleSwitch()
    {
        mainStackView.addArrangedSubview(toggleSwitch)
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchDidChangeValue), for: .valueChanged)
    }
    
    
    @objc private func toggleSwitchDidChangeValue()
    {
        guard let d = delegate else { fatalError("The view should have a delegate!") }
        d.switchDidChangeValue(to: toggleSwitch.isOn)
    }
    
}




// MARK: - Functions:
extension SearchResultsView
{
    
    public func setTextOnFoundLabel(_ text: String)
    {
        self.itemsFoundLabel.text = text
    }
    
}
