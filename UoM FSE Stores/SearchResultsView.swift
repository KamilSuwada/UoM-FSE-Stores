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


class SearchResultsView: UIView
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
        label.textAlignment = .center
        label.text = "Found: XX"
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
        label.textAlignment = .center
        label.text = "Search all FSE?"
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
    
    
    //MARK: - INITs:
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setup()
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        self.appearance = traitCollection.userInterfaceStyle
    }

}




// MARK: setup methods:
extension SearchResultsView
{
    
    private func setup()
    {
        setupView()
        setupMainStackView()
        setupLabels()
        setupToggleSwitch()
    }
    
    
    private func setupView()
    {
        backgroundColor = .systemPurple
    }
    
    
    private func setupMainStackView()
    {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            trailingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.trailingAnchor, multiplier: 3),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    private func setupLabels()
    {
        mainStackView.addArrangedSubview(itemsFoundLabel)
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




// MARK: - Functions()
extension SearchResultsView
{
    
    public func setTextOnFoundLabel(_ text: String)
    {
        self.itemsFoundLabel.text = text
    }
    
}
