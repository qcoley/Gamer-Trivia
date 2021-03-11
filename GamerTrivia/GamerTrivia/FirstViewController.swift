//
//  FirstViewController.swift
//  GamerTrivia
//
//  Created by Student Account  on 3/11/21.
//


import UIKit

class FirstViewController: UIViewController {
    
    
    @IBAction func One_Player_Button(_ sender: Any) {
        
        print("button pressed")
        self.performSegue(withIdentifier: "GenreViewSegue", sender: self)
    }
    
    @IBAction func Two_Player_Button(_ sender: Any) {
        
        print("button pressed")
        self.performSegue(withIdentifier: "GenreViewSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }}
