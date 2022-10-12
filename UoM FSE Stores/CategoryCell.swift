//
//  CategoryCell.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 12/10/2022.
//

import UIKit




class CategoryCell: UITableViewCell
{
    // MARK: - Properties:
    
    
    /// Reuse ID of the DepartmentCell.
    static let reuseID = "CategoryCell"
    
    
    /// Row height for the cell.
    static let rowHeight: CGFloat = 50
    
    
    /// Accessory type for the cell
    static let cellAccessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    
    
    /// Label to display deparment name.
    private let departmentNameLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
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
        contentView.addSubview(departmentNameLabel)
        
        NSLayoutConstraint.activate([
            departmentNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            departmentNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: departmentNameLabel.trailingAnchor, multiplier: 0),
            bottomAnchor.constraint(equalToSystemSpacingBelow: departmentNameLabel.bottomAnchor, multiplier: 1)
        ])
    }
    
    
    // MARK: - CONFIGURE:
    
    
    public func configure(with name: String)
    {
        self.departmentNameLabel.text = name
    }
    
    
    // MARK: - REUSE:
    
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        self.departmentNameLabel.text = nil
    }
}
