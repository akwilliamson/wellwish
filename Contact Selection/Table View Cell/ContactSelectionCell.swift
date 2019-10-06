//
//  ContactSelectionTableViewCell.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/24/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit
import Contacts

class ContactSelectionCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var datesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var birthdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var birthdayIndicatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var anniversaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var anniversaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var anniversaryIndicatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var selectionView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    
    var contact: CNContact?
    
    private var viewModel = ContactSelectionCellViewModel()
    
    required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        viewModel.delegate = self
    }
    
    public func setupViews() {
        constructViews()
        constrainViews()
    }
    
    private func constructViews() {
        guard let contact = contact else { return }
        // Name
        nameLabel.text = viewModel.fullName(for: contact)
        // Birthday
        birthdayLabel.text = viewModel.birthdayText
        birthdayIndicatorView.image = viewModel.birthdayImage(for: contact)
        // Anniversary
        anniversaryLabel.text = viewModel.anniversaryText
        anniversaryIndicatorView.image = viewModel.anniversaryImage(for: contact)
        // Selection
        selectionView.image = viewModel.selectionImage()
    }
    
    private func constrainViews() {
        // Subviews
        addSubview(selectionView)
        addSubview(nameLabel)
        addSubview(datesStackView)
        // DatesStackView > Subviews
        datesStackView.addArrangedSubview(birthdayStackView)
        datesStackView.addArrangedSubview(anniversaryStackView)
        
        birthdayStackView.addArrangedSubview(birthdayLabel)
        birthdayStackView.addArrangedSubview(birthdayIndicatorView)
        anniversaryStackView.addArrangedSubview(anniversaryLabel)
        anniversaryStackView.addArrangedSubview(anniversaryIndicatorView)
        
        NSLayoutConstraint.activate([
            selectionView.widthAnchor.constraint(equalToConstant: 30),
            selectionView.heightAnchor.constraint(equalToConstant: 30),
            selectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: selectionView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            datesStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            datesStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            datesStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            birthdayIndicatorView.widthAnchor.constraint(equalToConstant: 30),
            anniversaryIndicatorView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Methods
    
    public func contactIsSelected(isSelected: Bool) {
        viewModel.setSelectedState(isSelected: isSelected)
    }
}

extension ContactSelectionCell: ContactSelectionCellDelegate {
    
    // When a user selects or unselects a cell
    func updateSelectionImage(_ image: UIImage?) {
        selectionView.image = image
    }
}
