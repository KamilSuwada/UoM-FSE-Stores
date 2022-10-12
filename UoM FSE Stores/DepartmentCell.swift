//
//  DepartmentCell.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/10/2022.
//

import UIKit




class DepartmentCell: UITableViewCell
{
    // MARK: - Properties:
    
    
    /// Reuse ID of the DepartmentCell.
    static let reuseID = "DepartmentCell"
    
    
    /// Row height for the cell.
    static let rowHeight: CGFloat = 150
    
    
    /// Accessory type for the cell
    static let cellAccessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    
    
    
    private let mainStackView: UIStackView =
    {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.spacing = 20
        view.distribution = .fillProportionally
        view.axis = .horizontal
        return view
    }()
    
    
    /// Image View to display the image of the department.
    private let departmentImageView: UIImageView =
    {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    
    /// Label to display deparment name.
    private let departmentNameLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - INIT:
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup()
    {
        setupMainStackView()
        setupImageAndLabel()
    }
    
    
    private func setupMainStackView()
    {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            mainStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.trailingAnchor, multiplier: 0),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 1)
        ])
    }
    
    
    private func setupImageAndLabel()
    {
        mainStackView.addArrangedSubview(departmentImageView)
        mainStackView.addArrangedSubview(departmentNameLabel)
    }
    
    
    // MARK: - CONFIGURE:
    
    
    struct ViewModel
    {
        let departmentName: String
        let departmentImage: UIImage
    }
    
    
    public func configure(with model: ViewModel)
    {
        self.departmentNameLabel.text = model.departmentName
        self.departmentImageView.image = model.departmentImage
    }
    
    
    // MARK: - REUSE:
    
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        self.departmentNameLabel.text = nil
        self.departmentImageView.image = nil
    }
}
