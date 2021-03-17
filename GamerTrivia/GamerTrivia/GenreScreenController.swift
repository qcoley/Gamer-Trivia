//
//  GenreScreenController.swift
//  GamerTrivia
//
//  Created by Student Account  on 3/11/21.
//

import UIKit

class GenreScreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories: [Category] = []
    

    
    @IBOutlet var CategoryScreen: UIView!
    @IBOutlet weak var CategoryTable: UITableView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryTable.delegate = self
        CategoryTable.dataSource = self
        categories = createArray()  }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        
        cell.textLabel?.text = category.category
        
        return cell }
    
    
    func createArray() -> [Category] {
        
        var tempCategories: [Category] = []
        
        let category1 = Category(category: "MMO")
        let category2 = Category(category: "Console")
        let category3 = Category(category: "1980's")
        let category4 = Category(category: "1990's")
        let category5 = Category(category: "2000's")
        
        tempCategories.append(category1)
        tempCategories.append(category2)
        tempCategories.append(category3)
        tempCategories.append(category4)
        tempCategories.append(category5)
        
        return tempCategories  } }
