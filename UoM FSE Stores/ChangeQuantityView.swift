//
//  ChangeQuantityView.swift
//  UoM FSE Stores
//
//  Created by Kamil Suwada on 17/10/2022.
//

import UIKit; import RealmSwift


protocol ChangeQuantityViewDelegate: AnyObject
{
    func dataOfItemDidChange(at indexPath: IndexPath)
    func didResign(at indexPath: IndexPath)
}


class ChangeQuantityView: AboveKeyboardView
{
    //MARK: - Properties:
    
    
    let realm = try! Realm()
    
    
    /// Style of the users interface.
    private var appearance: UIUserInterfaceStyle?
    
    
    /// The item whose quantity is currently being edited.
    private var item: Item?
    
    
    /// The index path of the item whose quantity is currently being edited.
    private var indexPath: IndexPath?
    
    
    /// Delegate of the bubble view.
    weak var delegate: ChangeQuantityViewDelegate?
    
    
    /// Main stack view holds all UI components for this view.
    private let mainStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.backgroundColor = .clear
        return stack
    }()
    
    
    /// Secondary stack view holds text filed and button.
    private let secondaryStackView: UIStackView =
    {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 32
        stack.backgroundColor = .clear
        return stack
    }()
    
    
    /// Name of the item label.
    private let itemNameLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Item long name will go here and will be truncated if needed as it will be very likely too long."
        return label
    }()
    
    
    /// Quantity text field.
    let quantityTextField: UITextField =
    {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .asciiCapableNumberPad
        field.font = .systemFont(ofSize: 25, weight: .regular)
        field.backgroundColor = .clear
        field.textColor = .white
        field.textAlignment = .center
        field.placeholder = "123"
        field.tag = 2
        return field
    }()
    
    
    /// Trash button.
    let trashButton: UIButton =
    {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "trash.circle")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView!.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        return button
    }()
    
    
    /// Accept button.
    let acceptButton: UIButton =
    {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "checkmark.circle")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView!.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        return button
    }()
    
    
// MARK: - Setup:
    
    
    override func setup()
    {
        super.setup()
        setupSwipeRecogniser()
        setupMainStackView()
        setupItemNameLabel()
        setupSecondaryStackView()
        setupTrashButton()
        setupTextField()
        setupAcceptButton()
    }

}




// MARK: - Setup methods:
extension ChangeQuantityView
{
    
    private func setupSwipeRecogniser()
    {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .down
        swipe.addTarget(self, action: #selector(didSwipeDownOnView))
        addGestureRecognizer(swipe)
    }
    
    
    private func setupMainStackView()
    {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            mainStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            trailingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.trailingAnchor, multiplier: 3),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 0)
        ])
    }
    
    
    private func setupItemNameLabel()
    {
        mainStackView.addArrangedSubview(itemNameLabel)
        
        NSLayoutConstraint.activate([
            itemNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.leadingAnchor, multiplier: 0),
            mainStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: itemNameLabel.trailingAnchor, multiplier: 0)
        ])
    }
    
    
    private func setupSecondaryStackView()
    {
        mainStackView.addArrangedSubview(secondaryStackView)
        
        NSLayoutConstraint.activate([
            secondaryStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: mainStackView.leadingAnchor, multiplier: 0),
            mainStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: secondaryStackView.trailingAnchor, multiplier: 0)
        ])
    }
    
    
    private func setupTrashButton()
    {
        trashButton.addTarget(self, action: #selector(didTapTrashButton), for: .touchUpInside)
        secondaryStackView.addArrangedSubview(trashButton)
        
        NSLayoutConstraint.activate([
            trashButton.heightAnchor.constraint(equalTo: trashButton.widthAnchor),
            trashButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    private func setupTextField()
    {
        quantityTextField.delegate = self
        secondaryStackView.addArrangedSubview(quantityTextField)
        
        NSLayoutConstraint.activate([
            quantityTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    private func setupAcceptButton()
    {
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
        secondaryStackView.addArrangedSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            acceptButton.heightAnchor.constraint(equalTo: acceptButton.widthAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
}


// MARK: - UITextField Buttons and Swipes Handling:
extension ChangeQuantityView
{
    
    @objc private func didSwipeDownOnView(_ sender: UISwipeGestureRecognizer)
    {
        resign()
    }
    
    
    @objc private func didTapTrashButton(_ sender: UIButton)
    {
        guard let d = delegate else { fatalError("ChangeQuantityView does not have a delegate!") }
        guard let i = item else { fatalError("ChangeQuantityView does not have an associated item! Configure view before it is shown!") }
        guard let IP = indexPath else { fatalError("ChangeQuantityView should have an asociated index path for the item!") }
        do { try realm.write { i.changeQuantity(to: 0) }; notifyDataDidChange() }
        catch { print(error.localizedDescription) }
        d.dataOfItemDidChange(at: IP)
        resign()
        viewWillHide()
    }
    
    
    @objc private func didTapAcceptButton(_ sender: UIButton)
    {
        if let quantity = Int(quantityTextField.text!)
        {
            guard let d = delegate else { fatalError("ChangeQuantityView does not have a delegate!") }
            guard let i = item else { fatalError("ChangeQuantityView does not have an associated item! Configure view before it is shown!") }
            guard let IP = indexPath else { fatalError("ChangeQuantityView should have an asociated index path for the item!") }
            do { try realm.write { i.changeQuantity(to: quantity) }; notifyDataDidChange() }
            catch { print(error.localizedDescription) }
            d.dataOfItemDidChange(at: IP)
        }
        
        resign()
        viewWillHide()
    }
    
    
    private func notifyDataDidChange()
    {
        NotificationCenter.default.post(name: .dataDidChange, object: nil)
        print("DATA DID CHANGE NOTIFICATION POSTED BY: SearchQuantityView")
    }
    
}


// MARK: - UITextField Handling:
extension ChangeQuantityView: UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK: - Functions()
extension ChangeQuantityView
{
    
    private func activateView()
    {
        quantityTextField.becomeFirstResponder()
    }
    
    
    public func configureView(for item: Item, at indexPath: IndexPath, with activation: Bool = true)
    {
        self.item = item
        self.indexPath = indexPath
        self.quantityTextField.placeholder = "Currently: \(item.quantity)"
        self.itemNameLabel.text = item.name
        if activation { activateView() }
    }
    
    
    public func resign()
    {
        guard let d = delegate else { fatalError("ChangeQuantityView does not have a delegate!") }
        guard let IP = indexPath else { fatalError("ChangeQuantityView should have an asociated index path for the item!") }
        viewWillHide()
        quantityTextField.resignFirstResponder()
        d.didResign(at: IP)
        
    }
    
    
    private func viewWillHide()
    {
        self.quantityTextField.placeholder = nil
        self.quantityTextField.text = nil
        self.itemNameLabel.text = nil
        self.item = nil
        self.indexPath = nil
    }
    
}
