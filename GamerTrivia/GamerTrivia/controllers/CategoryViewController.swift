//
//  GenreScreenController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 3/22/21.
//

import UIKit
import CoreData
import AVFoundation

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Table: UITableView!
    
    let persistence = PersistenceService.shared
    
    var cats:[Categories]?
    var catsSorted:[Categories]?
    var selectedIndex: Int = 0
    var selectedCategory = ""
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground(imageName: "GeneralBackground")
        Table.delegate = self
        Table.dataSource = self
        // Grabs the current categories as loaded in CoreData for display in Table view
        persistence.fetch(Categories.self) { [weak self] (categories) in
            self?.cats = categories
            self?.catsSorted = self?.cats?.sorted() {$0.text! < $1.text!}
            self?.Table.reloadData()
        }
//        playSound(soundToPlay: "pacman_chomp")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catsSorted?.count ?? 0
    }
 
    // Populates the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        let category = self.catsSorted?[indexPath.row]
        let categoryQuestionCount = category?.questions?.count ?? 0
        cell.textLabel?.text = (category?.text)! + " (" + String(categoryQuestionCount) + ")"
        
        // Pretty up table for the custom background
        Table.tableFooterView = UIView(frame: .zero)
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
    
    // Sets the global selectedIndex to the currently selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    // Code for start game button
    @IBAction func startGame() {
        playSound(soundToPlay: "pacman_beginning")
        self.performSegue(withIdentifier: "StartGame", sender: self)
    }
    
    // Sets up passing the currently selected Category to the GameControllerView for filtering
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame" {
            let catset = self.catsSorted!
            let passedCat = catset[selectedIndex].text
            let vc = segue.destination as! GameViewController
            vc.selectedCategory = passedCat!
            vc.modalPresentationStyle = .fullScreen
        }
    }
}
