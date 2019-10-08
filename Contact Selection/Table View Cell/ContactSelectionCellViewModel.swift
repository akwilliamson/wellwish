//
//  ContactSelectionCellViewModel.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/25/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import UIKit
import Contacts

//protocol ContactDetailsProviding {
//    var fullName: String
//    var
//}

struct ContactSelectionCellViewModel {
    
    struct Constant {
        struct Key {
            static let anniversary = "Anniversary"
        }
        struct String {
            static let noName = "No Name"
            static let birthday = "Birthday:"
            static let anniversary = "Anniversary:"
        }
        struct Image {
            static let emptyCheckmark = "empty_checkmark"
            static let birthdayCheckmark = "birthday_checkmark"
            static let anniversaryCheckmark = "anniversary_checkmark"
            static let unselectedCheckmark = "unselected_checkmark"
            static let selectedCheckmark = "selected_checkmark"
        }
    }
    
    public var delegate: ContactSelectionCellDelegate?
    
    // Internal state used to toggle selected image
    private var isSelected = false {
        didSet {
            let isSelectedImage = selectionImage()
            delegate?.updateSelectionImage(isSelectedImage)
        }
    }
    
    public let birthdayText = Constant.String.birthday
    public let anniversaryText = Constant.String.anniversary
     
    public func fullName(for contact: CNContact) -> String {
        return CNContactFormatter.string(from: contact, style: .fullName) ?? Constant.String.noName
    }
    
    public func birthdayImage(for contact: CNContact) -> UIImage? {
        return contact.birthday != nil ?
            UIImage(named: Constant.Image.birthdayCheckmark)
            :
            UIImage(named: Constant.Image.emptyCheckmark)
    }
    
    public func anniversaryImage(for contact: CNContact) -> UIImage? {
        return anniversaryExists(in: contact.dates) ?
            UIImage(named: Constant.Image.anniversaryCheckmark)
            :
            UIImage(named: Constant.Image.emptyCheckmark)
    }
    
    private func anniversaryExists(in dateComponents: [CNLabeledValue<NSDateComponents>]) -> Bool {
        guard dateComponents.isEmpty == false else {  return false }

        let anniversaryValue = dateComponents.filter { date -> Bool in
            return date.label?.contains(Constant.Key.anniversary) ?? false
        }

        return anniversaryValue.isEmpty == false
    }
    
    public func selectionImage() -> UIImage? {
        return isSelected ?
            UIImage(named: Constant.Image.selectedCheckmark)
            :
            UIImage(named: Constant.Image.unselectedCheckmark)
    }
    
    public mutating func setSelectedState(isSelected: Bool) {
        self.isSelected = isSelected
    }
}
