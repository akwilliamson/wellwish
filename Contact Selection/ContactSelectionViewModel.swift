//
//  ContactSelectionViewModel.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/19/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import Foundation
import Contacts

struct ContactSelectionViewModel {
    
    struct Constant {
        struct Key {
            static let anniversary = "Anniversary"
        }
        struct String {
            static let noName = "No Name"
            static let selectAll = "Select All"
            static let clearSelection = "Clear All"
        }
    }
    
    public weak var delegate: ContactSelectionDelegate?
    
    private var contactSelectionStates: [Bool]
    private var allContactsAreSelected = false
    
    init(contactCount: Int) {
        contactSelectionStates = Array(repeating: false, count: contactCount)
    }
    
    public mutating func toggleContactSelection(at indexPath: IndexPath) -> Bool {
        let selectedContactState = contactSelectionStates[indexPath.row]
        contactSelectionStates[indexPath.row] = !selectedContactState
        
        return contactSelectionStates[indexPath.row]
    }
    
    public mutating func toggleAllContactSelections() {
        allContactsAreSelected = !allContactsAreSelected
        contactSelectionStates = contactSelectionStates.map { _ in return allContactsAreSelected }
        
        let toggleAllText = allContactsAreSelected ? Constant.String.clearSelection : Constant.String.selectAll
        delegate?.setToggleAllText(toggleAllText)
    }
    
    public func contactSelectionState(for row: Int) -> Bool {
        return contactSelectionStates[row]
    }
    
    public func fullName(for contact: CNContact) -> String {
        return CNContactFormatter.string(from: contact, style: .fullName) ?? Constant.String.noName
    }
}
