//
//  ContactsManager.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/5/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import Foundation
import Contacts

// Manages fetching and sanitizing CNContacts from a user's device
class ContactsManager {
    
    private let contactStore = CNContactStore()
    
    // TODO: Add anniversary key to fetch anniversaries
    private let keys: [CNKeyDescriptor] = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactBirthdayKey as CNKeyDescriptor,
        CNContactDatesKey as CNKeyDescriptor
    ]
    
    // MARK: Public Methods
    
    public func fetchContacts(completion: ([CNContact], Error?) -> Void) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        var contacts: [CNContact] = []
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest) { (contact, _) in
                contacts.append(contact)
            }
            completion(contacts, nil)
        } catch {
            completion([], error)
        }
    }

    // Get the birth date from the contact's birthday property if it exists
    public func birthDate(from dateComponents: DateComponents?)  -> Date? {
        guard let dateComponents = dateComponents else {  return nil }

        return dateComponents.date
    }

    // Get the anniversary date from the generic components if it exists
    public func anniversaryDate(from dateComponents: [CNLabeledValue<NSDateComponents>]) -> Date? {
        guard dateComponents.isEmpty == false else {  return nil }

        let anniversaryValue = dateComponents.filter { date -> Bool in
            return date.label?.contains("Anniversary") ?? false
        }

        let anniversaryComponents = anniversaryValue.first?.value as DateComponents?
        return anniversaryComponents?.date
    }
}
