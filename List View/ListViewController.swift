//
//  ListViewController.swift
//  date_dots
//
//  Created by Aaron Williamson on 8/18/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var launchView: LaunchView = {
        let view = LaunchView()
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Constants
    
    struct Constant {
        struct Key {
            static let hasSeenLaunchView = "HasSeenLaunchView"
        }
        struct Model {
            static let person = "Person"
        }
    }
    
    // MARK: - Properties
    
    var hasSeenLaunchView: Bool {
        return UserDefaults.standard.bool(forKey: Constant.Key.hasSeenLaunchView)
    }
    
    lazy var contactsManager = {
       return ContactsManager()
    }()
    
    lazy var coreDataManager = {
        return CoreDataManager(modelName: Constant.Model.person)
    }()
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Remove after completing feature
        UserDefaults.standard.set(false, forKey: Constant.Key.hasSeenLaunchView)
        configureView()
        constructViews()
        constrainViews()
    }
    
    private func configureView() {}
    
    private func constructViews() {
        view.addSubview(tableView)
        if !hasSeenLaunchView {
            view.addSubview(launchView)
        }
    }
    
    private func constrainViews() {
        // TableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        if !hasSeenLaunchView {
            // LaunchView
            NSLayoutConstraint.activate([
                launchView.topAnchor.constraint(equalTo: view.topAnchor),
                launchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                launchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                launchView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ListViewController: UITableViewDelegate {
}

extension ListViewController: LaunchViewDelegate {
    
    func userDidTapImportContacts() {
        UserDefaults.standard.set(true, forKey: Constant.Key.hasSeenLaunchView)
        retrieveContacts()
    }
    
    private func retrieveContacts() {
        contactsManager.fetchContacts { (contacts, error) in
            if let error = error {
                print(error)
            } else  {
                let viewController = ContactSelectionViewController(contacts: contacts)
                viewController.delegate = self
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    func userDidTapSkipImport() {
        UserDefaults.standard.set(true, forKey: Constant.Key.hasSeenLaunchView)
        launchView.removeFromSuperview()
    }
}

extension ListViewController: ListViewDelegate {
    func willDismissContactSelection() {
        launchView.removeFromSuperview()
    }
}
