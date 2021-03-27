//
//  GenreScreenController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 3/22/21.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Table: UITableView!
    
    let persistence = PersistenceService.shared
    
    var cats:[Categories]?  //
    var selectedIndex: Int = 0
    var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Table.delegate = self
        Table.dataSource = self
        
        // Grabs the current categories as loaded in CoreData for display in Table view
        persistence.fetch(Categories.self) { [weak self] (categories) in
            self?.cats = categories
            self?.Table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cats?.count ?? 0
    }
 
    // Populates the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        let category = self.cats?[indexPath.row]
        cell.textLabel?.text = category?.text
        return cell
    }
    
    // Sets the global selectedIndex to the currently selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    // Code for start game button
    @IBAction func startGame() {
        performSegue(withIdentifier: "StartGame", sender: self)
    }
    
    // Sets up passing the currently selected Category to the GameControllerView for filtering
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame" {
            let catset = self.cats!
            let passedCat = catset[selectedIndex].text
            let vc = segue.destination as! GameViewController
            vc.selectedCategory = passedCat!
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
