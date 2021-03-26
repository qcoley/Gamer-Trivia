//
//  AppDelegate.swift
//  GamerTrivia
//
//  Created by Jonathan Perz  on 3/22/21.
//

import UIKit
import CoreData



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !UserDefaults.standard.bool(forKey: "hasRunOnce") {
            UserDefaults.standard.setValue(true, forKey: "hasRunOnce")
            setupSampleData()
        }
      
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GamerTrivia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // NOTE: For import of JSON, we only need one of these looping through JSON file and tying JSON items to CoreData Objects.
    private func setupSampleData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
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
        
        saveContext()
    }
    
    

}

