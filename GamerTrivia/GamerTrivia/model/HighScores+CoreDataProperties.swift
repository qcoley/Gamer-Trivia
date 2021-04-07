//
//  HighScores+CoreDataProperties.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 4/6/21.
//
//

import Foundation
import CoreData


extension HighScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScores> {
        return NSFetchRequest<HighScores>(entityName: "HighScores")
    }

    @NSManaged public var score: Int64
    @NSManaged public var name: String?

}

extension HighScores : Identifiable {

}
