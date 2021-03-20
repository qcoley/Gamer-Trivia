//
//  GameViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 3/18/21.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameModels = [Questions]()
    var currentQuestion: Questions?
    var score = 0

    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        setupQuestions()
        configureUI(question: gameModels.first!)
    }
    
    private func configureUI(question: Questions) {
        label.text = question.text
        currentQuestion = question
        table.reloadData()
    }
    
    private func checkAnswer(answer: Answers, question: Questions) -> Bool {
        return question.answers.contains(where: { $0.text == answer.text }) && answer.correct
    }
    
    private func setupQuestions() {
        gameModels.append(Questions(text: "What is the nickname of the red ghost in Pac-Man?", answers: [
            Answers(text: "Stinky", correct: false),
            Answers(text: "Pinky", correct: false),
            Answers(text: "Blinky", correct: true),
            Answers(text: "Inky", correct: false)
            ], categories: [
            Categories(text: "1980's")],
            difficulty: 4))
        gameModels.append(Questions(text: "What is the nickname of the pink ghost in Pac-Man?", answers: [
            Answers(text: "Speedy", correct: false),
            Answers(text: "Pinky", correct: true),
            Answers(text: "Clyde", correct: false),
            Answers(text: "Blinky", correct: false)
            ], categories: [
            Categories(text: "1980's")],
            difficulty: 2))
        gameModels.append(Questions(text: "What is the nickname of the orange ghost in Pac-Man?", answers: [
            Answers(text: "Bashful", correct: false),
            Answers(text: "Speedy", correct: false),
            Answers(text: "Pokey", correct: false),
            Answers(text: "Clyde", correct: true)
            ], categories: [
            Categories(text: "1980's")],
            difficulty: 8)
        )
    }
    
    // Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let question = currentQuestion else {
            return
        }
        let answer = question.answers[indexPath.row]
            
        if checkAnswer(answer: answer, question: question) {
            // correct -> goes to next question or winner popup
            if let index = gameModels.firstIndex(where: { $0.text == question.text }) {
                if index < (gameModels.count - 1) {
                    //next question
                    let nextQuestion = gameModels[index + 1]
                    currentQuestion = nil
                    configureUI(question: nextQuestion)
                } else {
                    let alert = UIAlertController(title: "Done", message: "You have gained 10 nerd points", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    present(alert, animated: true)
                }
            }
        } else {
            // wrong
            let alert = UIAlertController(title: "Incorrect", message: "Hand in your gamer card.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            
        }
    }
}

struct Questions {
    let text: String
    let answers: [Answers]
    let categories: [Categories]
    let difficulty: Int
}

struct Answers {
    let text: String
    let correct: Bool //true /false
}

struct Categories {
    let text: String
}
