//
//  ViewController.swift
//  date_dots
//
//  Created by Aaron Williamson on 8/17/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    struct Constant {
        struct Key {
            static let hasSeenLaunch = "HasSeenLaunchViewController"
        }
        struct Model {
            static let person = "Person"
        }
        struct ImportContactsButton {
            static let title = "Import Contacts"
        }
        struct SkipButton {
            static let title = "Skip"
        }
    }
    
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
    
    // MARK: - Properties
    lazy var contactsManager = {
       return ContactsManager()
    }()
    
    lazy var coreDataManager = {
        return CoreDataManager(modelName: Constant.Model.person)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: Constant.Key.hasSeenLaunch)
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(importContactsButton)
        containerStackView.addArrangedSubview(skipButton)
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func didTapImportContactsButton() {
        UserDefaults.standard.set(true, forKey: Constant.Key.hasSeenLaunch)
        retrieveContacts()
    }
    
    @objc func didTapSkipButton() {
        UserDefaults.standard.set(true, forKey: Constant.Key.hasSeenLaunch)
        // Present ListViewController
    }
    
    private func retrieveContacts() {
        contactsManager.fetchContacts { (contacts, error) in
            if let error = error {
                print(error)
            } else  {
                let viewController = ContactSelectionViewController(contacts: contacts)
                present(viewController, animated: true, completion: nil)
            }
        }
    }
}
