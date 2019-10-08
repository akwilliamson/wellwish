//
//  ContactSelectionViewController.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/12/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit
import Contacts

/// Displays phone contacts to the user to choose which ones to import and which ones to skip.
class ContactSelectionViewController: UIViewController {
    
    // MARK: - UI
    
    private var toggleAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.String.selectAll, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(toggleAllTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.String.skip, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(skipImportTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .green
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var filterButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private var importSelectedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.String.importSelected, for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(importSelectedTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Constants
    
    struct Constant {
        struct Id {
            static let selectionCell = "ContactSelectionCell"
        }
        struct TableView {
            static let constraintTop: CGFloat = 50
            static let constraintBottom: CGFloat = -200
        }
        struct String {
            static let selectAll = "Select All"
            static let clearSelection = "Clear Selection"
            static let skip = "Skip"
            static let birthdays = "Birthdays"
            static let anniversaries = "Anniversaries"
            static let importSelected = "Import Selected"
        }
    }
    
    // MARK: - Properties
    
    public var delegate: ListViewDelegate?
    
    private let contacts: [CNContact]
    private var viewModel: ContactSelectionViewModel
    private let contactsManager = ContactsManager()
    private let coreDataManager = CoreDataManager(modelName: "Person")
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(contacts: [CNContact]) {
        self.contacts = contacts
        self.viewModel = ContactSelectionViewModel(contactCount: contacts.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureView()
        constructViews()
        constrainViews()
        tableView.reloadData()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
    private func constructViews() {
        view.addSubview(toggleAllButton)
        view.addSubview(skipButton)
        view.addSubview(tableView)
        view.addSubview(importSelectedButton)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            toggleAllButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            toggleAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            importSelectedButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25),
            importSelectedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            importSelectedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func toggleAllTapped(sender: UIButton) {
        viewModel.toggleAllContactSelections()
        tableView.reloadData()
    }
    
    @objc private func skipImportTapped(sender: UIButton) {
        if #available(iOS 13.0, *) {
            isModalInPresentation = false
        }
        delegate?.willDismissContactSelection()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func importSelectedTapped(sender: UIButton) {
        let selectedContacts = contacts.enumerated().compactMap { (index, contact) in
            return viewModel.isContactSelected(for: index) ? contact : nil
        }
        
        selectedContacts.forEach { contact in
            let person = Person(context: coreDataManager.managedContext)
            person.firstName = contact.givenName
            person.lastName = contact.familyName
            person.birthdate = contactsManager.birthDate(from: contact.birthday)
            person.anniversary = contactsManager.anniversaryDate(from: contact.dates)
        }

        coreDataManager.saveContext()
        delegate?.willDismissContactSelection()
        dismiss(animated: true, completion: nil)
    }
}

extension ContactSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectionCell = ContactSelectionCell()
        
        selectionCell.contact = contacts[indexPath.row]
        let isSelected = viewModel.isContactSelected(for: indexPath.row)
        selectionCell.setSelectedState(isSelected: isSelected)
        selectionCell.setupViews()
        
        return selectionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ContactSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isSelected = viewModel.toggleContactSelection(at: indexPath)
        let selectionCell = tableView.cellForRow(at: indexPath) as? ContactSelectionCell
        selectionCell?.setSelectedState(isSelected: isSelected)
    }
}

extension ContactSelectionViewController: ContactSelectionDelegate {
    
    func setToggleAllText(_ text: String) {
        toggleAllButton.setTitle(text, for: .normal)
    }
}
