//
//  Categories+CoreDataProperties.swift
//  GamerTrivia
//
//  Created by Khang Vo on 3/26/21.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var text: String?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension Categories {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Questions)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Questions)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

extension Categories : Identifiable {

}
