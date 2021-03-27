//
//  FirstViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 3/22/21.
//


import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    
    @IBAction func One_Player_Button() {
        let vc = storyboard?.instantiateViewController(identifier: "genre") as! CategoryViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
   @IBAction func Two_Player_Button() {
        let vc = storyboard?.instantiateViewController(identifier: "genre") as! CategoryViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func dismiss (_ unwindSegue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let managedContext = PersistenceService.shared.persistentContainer.viewContext
        managedContext.performAndWait {
            deleteData()
        }
        
        PersistenceService.shared.loadPersistenceData()
    }
    
    //Delete all instances of an entity
    func deleteData(){
        // create the delete request for the specified entity
        let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = Categories.fetchRequest()
        let categoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryFetchRequest)
        let questionFetchRequest: NSFetchRequest<NSFetchRequestResult> = Questions.fetchRequest()
        let questionDeleteRequest = NSBatchDeleteRequest(fetchRequest: questionFetchRequest)

        // get reference to the persistent container
        let persistentContainer = PersistenceService.shared.persistentContainer

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
    
}
