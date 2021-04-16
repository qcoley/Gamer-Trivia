//
//  GameViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 3/18/21.
//

import UIKit
import CoreData
import AVFoundation

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var questionset = [Questions]()
    var chosenQuestionArray = [Questions]()
    var answerset = [Answers]()
    var currentQuestion: Questions?
    var currentQuestionCounter = 1
    var score = 0
    var selectedCategory = " "
    var audioPlayer: AVAudioPlayer?

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var difficultyMultiplier: UILabel!
    @IBOutlet var questionCounter: UILabel!
    @IBOutlet var category: UILabel!
    
    let context = PersistenceService.shared.persistentContainer.viewContext
    var selectedIncorrectIndex = IndexPath(row: -1, section: 0)
    var selectedCorrectIndex = IndexPath(row: -1, section: 0)
    let SCORE_PENALTY = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground(imageName: "GeneralBackground")
        table.delegate = self
        table.dataSource = self
        fetchQuestions()
        chosenQuestionArray = Array(Set(questionset)).shuffled().suffix(10)
        configureUI(question: (chosenQuestionArray.first!))
    }
    
    private func configureUI(question: Questions) {
        label.text = question.text
        difficultyMultiplier.text = "Difficulty: " +   String(question.difficulty)
        questionCounter?.text = String(currentQuestionCounter) + " of " + String(chosenQuestionArray.count)
        currentQuestion = question
        scoreLabel.text = "Score: " + String(score)
        category.text = selectedCategory
        selectedIncorrectIndex = IndexPath(row: -1, section: 0)
        selectedCorrectIndex = IndexPath(row: -1, section: 0)
        table.reloadData()
    }
    
    private func playSound (soundToPlay: String) {
        let pathToSound = Bundle.main.path(forResource: soundToPlay, ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let err {
            print("Could not find sound filel", err)
        }
    }
    
    private func checkAnswer(answer: Answers, question: Questions) -> Bool {
        return (question.answers?.allObjects.contains(where: { ($0 as AnyObject).text == answer.text }))! && answer.correct
    }
    
    private func correctAnswer() {
        let earnedScore = 10 * Int(currentQuestion?.difficulty ?? 0)
        score = score + earnedScore
        scoreLabel.text = "Score: " + String(score)
        playSound(soundToPlay: "pacman_extrapac")
        let alert = UIAlertController(title: "Correct!", message: "You have been earned " + String(earnedScore) + " points.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in self.advanceCounter() }))
        present(alert, animated: true)
    }
    
    private func incorrectAnswer() {
        score = score - SCORE_PENALTY
        scoreLabel.text = "Score: " + String(score)
        playSound(soundToPlay: "pacman_death")
        // Comment out for Khang's change //
//        let alert = UIAlertController(title: "Incorrect", message: "You have been penalized 20 points.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        present(alert, animated: true)
        // ////////////////////////////// //
    }
    
    private func advanceCounter() {
        currentQuestionCounter = currentQuestionCounter + 1
        isThisTheLastQuestion()
    }
    
    private func nextQuestion() {
        let nextQuestion = chosenQuestionArray[currentQuestionCounter-1]
        currentQuestion = nil
        configureUI(question: nextQuestion)
    }
    
    private func isThisTheLastQuestion() {
        if currentQuestionCounter == chosenQuestionArray.count + 1 {
            gameFinal()
        } else {


            nextQuestion()
        }
    }
    
    private func gameFinal() {
        let alert = UIAlertController(title: "Congratulations!", message: "You have scored " + String(score) + " points", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:  { action in self.segueToHighScores() }))
        self.present(alert, animated: true)
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
        
        // Pretty up table view for custom background
        table.tableFooterView = UIView(frame: .zero)
        cell.textLabel?.textColor = UIColor.white
//        cell.answerLabel?.textAlignment = NSTextAlignment.center
        
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
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 2
        
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = bgColorView
        
        // Uncomment to apply Khang's change //
        
        if selectedIncorrectIndex == indexPath {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
            let pointAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

            let partOne = NSMutableAttributedString(string: cell.textLabel?.text ?? "", attributes: textAttributes)
            let partTwo = NSMutableAttributedString(string: " [-\(SCORE_PENALTY)]", attributes: pointAttributes)

            let combination = NSMutableAttributedString()

            combination.append(partOne)
            combination.append(partTwo)

            cell.textLabel?.attributedText = combination
        }

        if selectedCorrectIndex == indexPath {
            let earnedScore = 10 * Int(currentQuestion?.difficulty ?? 0)
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
            let pointAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green]

            let partOne = NSMutableAttributedString(string: cell.textLabel?.text ?? "", attributes: textAttributes)
            let partTwo = NSMutableAttributedString(string: " [+\(earnedScore)]", attributes: pointAttributes)

            let combination = NSMutableAttributedString()

            combination.append(partOne)
            combination.append(partTwo)

            cell.textLabel?.attributedText = combination
        }
        
        // ///////////////////////////////// //
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let question = currentQuestion else { return }
        let answers = answerset[indexPath.row]
        let indexesToRedraw = [indexPath]
        if checkAnswer(answer: answers, question: question) {
            correctAnswer()
            selectedCorrectIndex = indexPath
            tableView.reloadRows(at: indexesToRedraw, with: .fade)
        } else {
            incorrectAnswer()
            selectedIncorrectIndex = indexPath
            tableView.reloadRows(at: indexesToRedraw, with: .fade)
        }
    }
    
    private func segueToHighScores() {
        performSegue(withIdentifier: "HighScoreEntry", sender: nil)
    }
    
    // Sets up passing the current Score to be passed to HighScoreControllerView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HighScoreEntry" {
            let passedScore = self.score
            let vc = segue.destination as! HighScoresViewController
            vc.passedScore = passedScore
            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
        }
    }
}
