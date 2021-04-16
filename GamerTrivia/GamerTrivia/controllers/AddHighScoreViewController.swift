//
//  AddHighScoreViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 4/6/21.
//

import UIKit
import CoreData

class AddHighScoreViewController: UIViewController, UITextFieldDelegate {
    
    var parentVC: HighScoresViewController!
    
    @IBOutlet var alertView: UIView!
    @IBOutlet var name: UITextField!
    @IBOutlet var score: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        setupToLookPretty()
        score.text = String(parentVC.passedScore)
    }
    
    func textFieldShouldReturn(_ name: UITextField) -> Bool {
        name.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveData(_ sender: Any) {
        let context = PersistenceService.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HighScores", in: context)
        let newHighScore = NSManagedObject(entity: entity!, insertInto: context)
        newHighScore.setValue(name.text, forKey: "name")
        newHighScore.setValue(Int64(score.text ?? "0"), forKey: "score")
        
        do {
            try context.save()
        } catch {
            print ("Update High Score Failed")
        }
        
        self.dismiss(animated: true, completion: {})
        parentVC.reloadTable()
    }
    
    func setupToLookPretty() {
        alertView.layer.cornerRadius = 8.0
        alertView.layer.borderWidth = 3.0
        alertView.layer.borderColor = UIColor.gray.cgColor
        name.becomeFirstResponder()
    }

    
}
