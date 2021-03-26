//
//  GameViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 3/18/21.
//

import UIKit
import CoreData

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var questionset = [Questions]()
    var answerset = [Answers]()
    var currentQuestion: Questions?
    var score = 0
    var selectedCategory = " "

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    
<<<<<<< refs/remotes/origin/development
=======
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
>>>>>>> Finished connect CoreData with three sample questions. CategoryViewController now applies filter to GameViewController. Added some fundamental scoring for answering questions ( + 10 * difficulty multiplier for correct answers and - 20 for incorrect answers).
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        fetchQuestions()
        configureUI(question: (questionset.first!))
    }
    
    private func configureUI(question: Questions) {
        label.text = question.text
        currentQuestion = question
        scoreLabel.text = "Score: " + String(score)
        table.reloadData()
    }
    
    private func checkAnswer(answer: Answers, question: Questions) -> Bool {
        return (question.answers?.allObjects.contains(where: { ($0 as AnyObject).text == answer.text }))! && answer.correct
    }
    
    // Fetches questions and filters them based on the categories.
    func fetchQuestions() {
        let filter = selectedCategory
        let predicate = NSPredicate(format: "ANY categories.text LIKE %@", filter)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Questions")
        request.predicate = predicate
        do {
            self.questionset = try context.fetch(request) as! [Questions]
        } catch let err {
            print("Error in fetching questions", err)
        }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
    }
    
    // Table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        answerset = currentQuestion?.answers?.allObjects as! [Answers]
        cell.textLabel?.text = answerset[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let question = currentQuestion else {
            return
        }
        let answers = answerset[indexPath.row]

        if checkAnswer(answer: answers, question: question) {
            score = score + 10 * Int(currentQuestion?.difficulty ?? 0)
            scoreLabel.text = "Score: " + String(score)
            // correct --> goes to next question or winner popup
            if let index = questionset.firstIndex(where: { $0.text == question.text }) {
                if index < (questionset.count - 1) {
                    //next question
                    let nextQuestion = questionset[index + 1]
                    currentQuestion = nil
                    configureUI(question: nextQuestion)
                } else {
                    let alert = UIAlertController(title: "Congratulations!", message: "You have scored " + String(score) + " points", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    present(alert, animated: true)
                }
            }
        } else {
            // wrong --> deduct penalty of 20 points, update score title and popup notice of penalty
            score = score - 20
            scoreLabel.text = "Score: " + String(score)
            let alert = UIAlertController(title: "Incorrect", message: "You have been penalized 20 points.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)

        }
    }
}
