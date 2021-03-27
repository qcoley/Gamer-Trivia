//
//  Questions+CoreDataProperties.swift
//  GamerTrivia
//
//  Created by Khang Vo on 3/26/21.
//
//

import Foundation
import CoreData


extension Questions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Questions> {
        return NSFetchRequest<Questions>(entityName: "Questions")
    }

    @NSManaged public var difficulty: Int64
    @NSManaged public var image: Data?
    @NSManaged public var text: String?
    @NSManaged public var answers: NSSet?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for answers
extension Questions {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: Answers)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: Answers)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}

// MARK: Generated accessors for categories
extension Questions {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Categories)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Categories)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

extension Questions : Identifiable {

}
