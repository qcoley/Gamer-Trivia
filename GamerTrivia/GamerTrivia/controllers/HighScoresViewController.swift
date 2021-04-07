//
//  HighScoresViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 4/6/21.
//

import UIKit
import CoreData
import AVFoundation

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var highscores: [HighScores]?
    var passedScore = 0

    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    
    @IBAction func Continue(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "GameOver") as! GameOverViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    
    let context = PersistenceService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground(imageName: "GeneralBackground")
        table.delegate = self
        table.dataSource = self
        getScores()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        evaluateScore()
    }
    
    func reloadTable() {
        getScores()
        table.reloadData()
    }
    
    func getScores() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HighScores")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        
        do {
            highscores = try ((managedContext.fetch(fetchRequest) as? [HighScores])!)
        table.reloadData()
            print(highscores as Any)
        } catch let err as NSError {
            print ("Could not fetch. \(err), \(err.userInfo)")
        }
    }
    
    // Table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highscores!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let highscore = self.highscores?[indexPath.row]
        cell.textLabel?.text = (highscore?.name)! + " ....... " + String(highscore!.score)
        
        
        table.tableFooterView = UIView(frame: .zero)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        guard let customFont = UIFont(name: "Arcade", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        cell.textLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel?.font = customFont.withSize(24)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    private func evaluateScore() {
        print (passedScore, highscores?.last?.score as Any, highscores!.count)
        if passedScore > (highscores?.last?.score)! && highscores!.count < 10 {
            createCustomAlert()
        }
    }
    
    func createCustomAlert() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let alertVC = sb.instantiateViewController(identifier: "AddHighScoreViewController") as! AddHighScoreViewController
        alertVC.parentVC = self
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
        
    }
}
