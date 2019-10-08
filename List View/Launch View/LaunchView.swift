//
//  LaunchView.swift
//  WellWish
//
//  Created by Aaron Williamson on 10/6/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit

class LaunchView: UIView {
    
    // MARK: - UI
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var importContactsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.ImportContactsButton.title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapImportContactsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.SkipButton.title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Constants
    
    struct Constant {
        struct ImportContactsButton {
            static let title = "Import Contacts"
        }
        struct SkipButton {
            static let title = "Skip"
        }
    }
    
    // MARK: - Properties

    var delegate: LaunchViewDelegate?
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        constructViews()
        constrainViews()
    }
    
    // MARK: - View Setup
    
    private func configureView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constructViews() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(importContactsButton)
        containerStackView.addArrangedSubview(skipButton)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - User Ations
    
    @objc func didTapImportContactsButton() {
        delegate?.userDidTapImportContacts()
    }
    
    @objc func didTapSkipButton() {
        delegate?.userDidTapSkipImport()
    }
}
