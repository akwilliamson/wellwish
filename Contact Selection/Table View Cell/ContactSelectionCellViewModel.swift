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
     
//    public func dates(for contact: CNContact) -> String {
//        let birthdate = formattedBirthdate(from: contact.birthday)
//        let anniversary = formattedAnniversary(from: contact.dates)
//
//        return "Birthday: \(birthdate) Anniversary: \(anniversary)"
//    }
//
//    private func formattedBirthdate(from dateComponents: DateComponents?) -> String {
//        guard let birthDate = birthDate(from: dateComponents) else {
//            return Constant.String.noDate
//        }
//
//        return formattedDateString(from: birthDate)
//    }
//
//    // Get the birth date from the contact's birthday property if it exists
//    private func birthDate(from dateComponents: DateComponents?)  -> Date? {
//        guard let dateComponents = dateComponents else {  return nil }
//
//        return dateComponents.date
//    }
//
//    private func formattedAnniversary(from dateComponents: [CNLabeledValue<NSDateComponents>]) -> String {
//        guard let anniversaryDate = anniversaryDate(from: dateComponents) else {
//            return Constant.String.noDate
//        }
//
//        return formattedDateString(from: anniversaryDate)
//    }
//
//    // Get the anniversary date from the generic components if it exists
//    private func anniversaryDate(from dateComponents: [CNLabeledValue<NSDateComponents>]) -> Date? {
//        guard dateComponents.isEmpty == false else {  return nil }
//
//        let anniversaryValue = dateComponents.filter { date -> Bool in
//            return date.label?.contains(Constant.Key.anniversary) ?? false
//        }
//
//        let anniversaryComponents = anniversaryValue.first?.value as DateComponents?
//        return anniversaryComponents?.date
//    }
//
//    private func formattedDateString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//
//        return formatter.string(from: date)
//    }
}
