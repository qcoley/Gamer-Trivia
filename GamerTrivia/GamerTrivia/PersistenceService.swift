//
//  PersistenceService.swift
//  GamerTrivia
//
//  Created by Khang Vo on 3/26/21.
//

import Foundation
import CoreData

public class PersistenceService {
    
    private init () {
    }
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GamerTrivia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void){
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        do {
            let objects = try context.fetch(request)
            completion(objects)
        } catch {
            print(error)
            completion([])
        }
    }
    
    func loadPersistenceData(){
        
            UserDefaults.resetStandardUserDefaults()
            
            if !UserDefaults.standard.bool(forKey: "hasRunOnce") {
                UserDefaults.standard.setValue(true, forKey: "hasRunOnce")
                setupSampleData()
                setUpDefaultScores()
                print ("Setting up Sample Data and Default Scores")
            }
        
        if let localData = self.readLocalFile(forName: "data") {
            self.parse(jsonData: localData)
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
            {
                print ("[PersistenceService] JSON File data found in '\(name)'")
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
               if let json = try JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers])
                as? [String: AnyObject] {
                
                guard let categoriesJsonArray = json["categories"] as? [String] else
                {
                    return print("[PersistenceService] error unwrapping json objects")
                }
                
                guard let questionsJsonArray = json["questions"] as? [AnyObject] else
                {
                    return print("[PersistenceService] error unwrapping json objects")
                }
                
                self.saveCategoriesInCoreDataWith(array: categoriesJsonArray)
                
                for question in questionsJsonArray {
                    self.saveQuestionsInCoreDataWith(array: question as! [String : AnyObject])
                }
               print ("[PersistenceService] Parsing JSON file")
            }
        } catch let error {
            print(error)
        }
    }
    
    private func saveCategoriesInCoreDataWith(array: [String]) {
        _ = array.map{self.createCategoryEntityFrom(text: $0)}
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func createCategoryEntityFrom(text: String) -> NSManagedObject? {
        let context = persistentContainer.viewContext
        
        let request : NSFetchRequest<Categories> = Categories.fetchRequest()
        let predicate = NSPredicate(format: "text = %@", text)
        request.predicate = predicate
        request.fetchLimit = 1
        do{
            let count = try context.count(for: request)

            if(count == 0){
//                print("no matches")
                
                if let categoryEntity = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context) as? Categories {
                        categoryEntity.text = text
                        return categoryEntity
                }
                return nil
            }
            else{
                print("\(text) match found")
        
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    private func saveQuestionsInCoreDataWith(array: [String : AnyObject]) {
        
        guard
            let questionCategories = array["categories"] as? [String],
            let questionText = array["text"] as? String,
            let questionDifficulty = array["difficulty"] as? Int64,
            let questionAnswers = array["answers"] as? [AnyObject]
        
        else {
            return print("saveQuestionsInCoreDataWith() error")
        }
        
        createQuestionEntityFrom(text: questionText,
                                 categories: questionCategories,
                                 difficulty: questionDifficulty,
                                 answers: questionAnswers)
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func createQuestionEntityFrom(text: String,
                                          categories: [String],
                                          difficulty: Int64,
                                          answers: [AnyObject]){

        let context = persistentContainer.viewContext

        let request : NSFetchRequest<Questions> = Questions.fetchRequest()
        let predicate = NSPredicate(format: "text = %@", text)
        request.predicate = predicate
        request.fetchLimit = 1

        do{
            let count = try context.count(for: request)

            if(count == 0){
//                print("no question matches")

                if let questionEntity = NSEntityDescription.insertNewObject(forEntityName: "Questions", into: context) as? Questions {
                    questionEntity.text = text
                    questionEntity.difficulty = difficulty

                    let request : NSFetchRequest<Categories> = Categories.fetchRequest()

                    do {
                        let categoriesFetch = try context.fetch(request)
                        
                        for category in categoriesFetch {
//                            print(questionEntity.text!)
//                            print(categories.description)
//                            print(String(category.text!))
                            if (categories.contains(category.text!)) {
                                questionEntity.addToCategories(category)
//                                print("\(questionEntity.text!) added to \(String(describing: category.text))")
                            }
                        }
                        
                        for answerObject in answers {
                            guard let answerDict = answerObject as? [String : AnyObject] else {
                                
                                return print("Error parsing answer object")
                            }
                            
                            if let answerEntity = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as? Answers {
                                answerEntity.text = answerDict["text"] as? String
                                answerEntity.correct = answerDict["correct"] as? Bool ?? false
                                answerEntity.questions = questionEntity
                            }
                        }
                    } catch let error as NSError {
                        print("Could not fetch. \(error), \(error.userInfo)")
                    }

                }
                return
            }
            else{
//                print("'\(text)' question match found")

            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return
    }
    
    //Delete all instances of an entity
    func deleteData(){
        // create the delete request for the specified entity
        let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = Categories.fetchRequest()
        let categoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryFetchRequest)
        let questionFetchRequest: NSFetchRequest<NSFetchRequestResult> = Questions.fetchRequest()
        let questionDeleteRequest = NSBatchDeleteRequest(fetchRequest: questionFetchRequest)

        // perform the delete
        do {
            try persistentContainer.viewContext.execute(categoryDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
        do {
            try persistentContainer.viewContext.execute(questionDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    // NOTE: For import of JSON, we only need one of these looping through JSON file and tying JSON items to CoreData Objects.
    private func setupSampleData() {
        // Add first Sample Question
        let newQuestion = NSEntityDescription.insertNewObject(forEntityName: "Questions", into: context) as! Questions
        newQuestion.text = "What is the nickname of the red ghost in Pac-Man?"
        newQuestion.difficulty = 4
        newQuestion.image = nil

        let answer1 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer1.text = "Stinky"
        answer1.correct = false
        answer1.questions = newQuestion
        let answer2 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer2.text = "Pinky"
        answer2.correct = false
        answer2.questions = newQuestion
        let answer3 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer3.text = "Blinky"
        answer3.correct = true
        answer3.questions = newQuestion
        let answer4 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer4.text = "Inky"
        answer4.correct = false
        answer4.questions = newQuestion

        newQuestion.answers = [answer1, answer2, answer3, answer4]
        
        // Add categories
        let cat1 = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context) as! Categories
        cat1.text = "1980's"
        let cat2 = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context) as! Categories
        cat2.text = "Arcade"
        
        cat1.addToQuestions(newQuestion)

        
        newQuestion.addToCategories(cat1)

        
        // Add second Sample Question
        let newQuestion2 = NSEntityDescription.insertNewObject(forEntityName: "Questions", into: context) as! Questions
        newQuestion2.text = "What is the nickname of the pink ghost in Pac-Man?"
        newQuestion2.difficulty = 1
        newQuestion2.image = nil

        let answer5 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer5.text = "Speedy"
        answer5.correct = false
        answer5.questions = newQuestion2
        let answer6 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer6.text = "Pinky"
        answer6.correct = true
        answer6.questions = newQuestion2
        let answer7 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer7.text = "Clyde"
        answer7.correct = false
        answer7.questions = newQuestion2
        let answer8 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer8.text = "Blinky"
        answer8.correct = false
        answer8.questions = newQuestion2

        newQuestion2.answers = [answer5, answer6, answer7, answer8]
        
        cat1.addToQuestions(newQuestion2)
        cat2.addToQuestions(newQuestion2)
        
        newQuestion2.addToCategories(cat1)
        newQuestion2.addToCategories(cat2)

        // Add third Sample Question
        let newQuestion3 = NSEntityDescription.insertNewObject(forEntityName: "Questions", into: context) as! Questions
        newQuestion3.text = "What is the character of the orange ghost in Pac-Man?"
        newQuestion3.difficulty = 8
        newQuestion3.image = nil

        let answer9 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer9.text = "Bashful"
        answer9.correct = false
        answer9.questions = newQuestion3
        let answer10 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer10.text = "Speedy"
        answer10.correct = true
        answer10.questions = newQuestion3
        let answer11 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer11.text = "Pokey"
        answer11.correct = true
        answer11.questions = newQuestion3
        let answer12 = NSEntityDescription.insertNewObject(forEntityName: "Answers", into: context) as! Answers
        answer12.text = "Clyde"
        answer12.correct = false
        answer12.questions = newQuestion3

        newQuestion3.answers = [answer9, answer10, answer11, answer12]
        
        cat1.addToQuestions(newQuestion3)
        cat2.addToQuestions(newQuestion3)
        
        newQuestion3.addToCategories(cat1)
        newQuestion3.addToCategories(cat2)
        
        save ()
    }
    
    private func setUpDefaultScores() {
        let defaultScore1 = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context) as! HighScores
        defaultScore1.name = "DexWasHere"
        defaultScore1.score = 120
        
        let defaultScore2 = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context) as! HighScores
        defaultScore2.name = "Deepshadow"
        defaultScore2.score = 80
        
        let defaultScore3 = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context) as! HighScores
        defaultScore3.name = "Veras"
        defaultScore3.score = 100
        
        let defaultScore4 = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context) as! HighScores
        defaultScore4.name = "Thogrun"
        defaultScore4.score = 100
        
        save()
    }

}


