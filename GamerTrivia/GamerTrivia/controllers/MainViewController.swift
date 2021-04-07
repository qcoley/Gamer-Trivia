//
//  MainViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 4/2/21.
//

import UIKit
import CoreData
import SwiftUI
import AVFoundation

class MainViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?

    @IBAction func insertCoin() {
        playSound(soundToPlay: "insertCoin")
        let vc = storyboard?.instantiateViewController(identifier: "genre") as! CategoryViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground()
        
        let managedContext = PersistenceService.shared.persistentContainer.viewContext
        managedContext.performAndWait {
            deleteData()
        }
        
        PersistenceService.shared.loadPersistenceData()
    }
    
    private func playSound (soundToPlay: String) {
        let pathToSound = Bundle.main.path(forResource: soundToPlay, ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let err {
            print("Could not find sound filel", err)
        }
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
