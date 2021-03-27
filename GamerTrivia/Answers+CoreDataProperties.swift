//
//  Answers+CoreDataProperties.swift
//  GamerTrivia
//
//  Created by Khang Vo on 3/26/21.
//
//

import Foundation
import CoreData


extension Answers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answers> {
        return NSFetchRequest<Answers>(entityName: "Answers")
    }

    @NSManaged public var correct: Bool
    @NSManaged public var text: String?
    @NSManaged public var questions: Questions?

}

extension Answers : Identifiable {

}
