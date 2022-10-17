//
//  ItemCell.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 12/10/2022.
//

import UIKit


protocol ItemCellDelegate: AnyObject
{
    func didTapPlusOne(for item: Item, at indexPath: IndexPath?)
    func didTapMinusOne(for item: Item, at indexPath: IndexPath?)
    func didTapFavourite(for item: Item, at indexPath: IndexPath?)
}


class ItemCell: UITableViewCell
{
    // MARK: - Properties:
    
    
    /// Delegate of the cell.
    weak var delegate: ItemCellDelegate?
    
    
    /// Copy of the item struct.
    private var item: Item?
    
    
    /// IndexPath of the item.
    private var indexPath: IndexPath?
    
    
    /// Reuse ID of the DepartmentCell.
    static let reuseID = "ItemCell"
    
    
    /// Row height for the cell.
    static let rowHeight: CGFloat = 175
    
    
    /// Accessory type for the cell
    static let cellAccessoryType: UITableViewCell.AccessoryType = .none
    
    
    /// Main stack view to house the UI components.
    private let mainStackView: UIStackView =
    {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.spacing = 8
        view.distribution = .fillProportionally
        view.axis = .vertical
        return view
    }()
    
    
    /// Stack view to house item image and item full name label.
    private let topStackView: UIStackView =
    {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.spacing = 20
        view.distribution = .fillProportionally
        view.axis = .horizontal
        return view
    }()
    
    
    /// Stack view to house item issue quantity, code and price labels.
    private let middleStackView: UIStackView =
    {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    
    /// Stack view to house favourite, plus and minus buttons along quantity label.
    private let bottomStackView: UIStackView =
    {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.distribution = .equalCentering
        view.axis = .horizontal
        return view
    }()
    
    
    /// Image View to display the image of the item.
    private let itemImageView: UIImageView =
    {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    
    /// Label to display item name.
    private let itemNameLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    
    /// Label to display item issue qunatity.
    private let itemUnitIssueLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    
    /// Label to display item code.
    private let itemCodeLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    
    /// Label to display item price.
    private let itemPriceLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    
    /// Button which allows the user set the item as favourite.
    private let favouriteButton: UIButton =
    {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let emptyHeart = UIImage(systemName: "heart")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let filledHeart = UIImage(systemName: "heart.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        button.setImage(emptyHeart, for: .normal)
        button.setImage(filledHeart, for: .selected)
        button.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.heightAnchor.constraint(equalToConstant: 37.5).isActive = true
        button.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    
    
    /// Button which allows the user to remove one from the order quantity.
    private let minusOneButton: UIButton =
    {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let minus = UIImage(systemName: "minus.circle")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        button.setImage(minus, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView!.contentMode = .scaleAspectFill
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 37.5).isActive = true
        return button
    }()
    
    
    /// Label to display item quantity.
    private let itemQuantityLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 35, weight: .regular)
        label.text = "0"
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    
    /// Button which allows the user to add one to the order quantity.
    private let plusOneButton: UIButton =
    {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let plus = UIImage(systemName: "plus.circle")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        button.setImage(plus, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView!.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 37.5).isActive = true
        return button
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
        setupButtons()
        setupMainStackView()
        setupSecondaryStackViews()
        setupTopStackView()
        setupMiddleStackView()
        setupBottomStackView()
    }
    
    
    private func setupButtons()
    {
        favouriteButton.addTarget(self, action: #selector(didTapFavouriteButton), for: .touchUpInside)
        minusOneButton.addTarget(self, action: #selector(didTapMinusOneButton), for: .touchUpInside)
        plusOneButton.addTarget(self, action: #selector(didTapPlusOneButton), for: .touchUpInside)
    }
    
    
    private func setupMainStackView()
    {
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            mainStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.trailingAnchor, multiplier: 0),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 1)
        ])
    }
    
    
    private func setupSecondaryStackViews()
    {
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(middleStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.leadingAnchor, multiplier: 1),
            mainStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 1),
            
            middleStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.leadingAnchor, multiplier: 1),
            mainStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: middleStackView.trailingAnchor, multiplier: 1),
            
            bottomStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.leadingAnchor, multiplier: 4),
            mainStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackView.trailingAnchor, multiplier: 4),
        ])
    }
    
    
    private func setupTopStackView()
    {
        topStackView.addArrangedSubview(itemImageView)
        topStackView.addArrangedSubview(itemNameLabel)
        
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: topStackView.topAnchor, multiplier: 0),
            topStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemNameLabel.bottomAnchor, multiplier: 0),
        ])
    }
    
    
    private func setupMiddleStackView()
    {
        middleStackView.addArrangedSubview(itemUnitIssueLabel)
        middleStackView.addArrangedSubview(itemCodeLabel)
        middleStackView.addArrangedSubview(itemPriceLabel)
        
        NSLayoutConstraint.activate([
            itemUnitIssueLabel.topAnchor.constraint(equalToSystemSpacingBelow: middleStackView.topAnchor, multiplier: 0),
            middleStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemUnitIssueLabel.bottomAnchor, multiplier: 0),
            
            itemCodeLabel.topAnchor.constraint(equalToSystemSpacingBelow: middleStackView.topAnchor, multiplier: 0),
            middleStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemCodeLabel.bottomAnchor, multiplier: 0),
            
            itemPriceLabel.topAnchor.constraint(equalToSystemSpacingBelow: middleStackView.topAnchor, multiplier: 0),
            middleStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemPriceLabel.bottomAnchor, multiplier: 0),
        ])
    }
    
    
    private func setupBottomStackView()
    {
        bottomStackView.addArrangedSubview(favouriteButton)
        bottomStackView.addArrangedSubview(minusOneButton)
        bottomStackView.addArrangedSubview(itemQuantityLabel)
        bottomStackView.addArrangedSubview(plusOneButton)
        
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.topAnchor, multiplier: 0),
            bottomStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: favouriteButton.bottomAnchor, multiplier: 0),
            
            minusOneButton.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.topAnchor, multiplier: 0),
            bottomStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: minusOneButton.bottomAnchor, multiplier: 0),
            
            itemQuantityLabel.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.topAnchor, multiplier: 0),
            bottomStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemQuantityLabel.bottomAnchor, multiplier: 0),
            
            plusOneButton.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.topAnchor, multiplier: 0),
            bottomStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: plusOneButton.bottomAnchor, multiplier: 0),
        ])
    }
    
    
    // MARK: - Button Actions:
    
    
    @objc private func didTapFavouriteButton(_ sender: UIButton)
    {
        guard let i = self.item else { fatalError("ItemCell should have an associated item!") }
        guard let d = delegate else { fatalError("ItemCell should have a delegate!") }
        d.didTapFavourite(for: i, at: self.indexPath!)
    }
    
    
    @objc private func didTapPlusOneButton(_ sender: UIButton)
    {
        guard let i = self.item else { fatalError("ItemCell should have an associated item!") }
        guard let d = delegate else { fatalError("ItemCell should have a delegate!") }
        d.didTapPlusOne(for: i, at: self.indexPath!)
    }
    
    
    @objc private func didTapMinusOneButton(_ sender: UIButton)
    {
        guard let i = self.item else { fatalError("ItemCell should have an associated item!") }
        guard let d = delegate else { fatalError("ItemCell should have a delegate!") }
        d.didTapMinusOne(for: i, at: self.indexPath!)
    }
    
    
    // MARK: - CONFIGURE:
    
    
    public func configure(with item: Item, at indexPath: IndexPath)
    {
        self.item = item
        self.indexPath = indexPath
        self.itemNameLabel.text = item.name
        self.itemImageView.image = UIImage(systemName: "circle")
        self.itemCodeLabel.text = item.code
        self.itemPriceLabel.text = item.formattedListPrice
        self.itemUnitIssueLabel.text = item.unitIssue
        self.itemQuantityLabel.text = "\(item.quantity)"
        self.favouriteButton.isSelected = item.isFavourite
    }
    
    
    // MARK: - REUSE:
    
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        self.delegate = nil
        self.indexPath = nil
        self.itemNameLabel.text = nil
        self.itemImageView.image = nil
        self.itemCodeLabel.text = nil
        self.itemPriceLabel.text = nil
        self.itemUnitIssueLabel.text = nil
        self.favouriteButton.isSelected = false
        self.itemQuantityLabel.text = nil
    }
}
