//
//  GameOverViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 4/7/21.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBAction func PlayAgain(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "mainview") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground(imageName: "GameOverBackground")
        
    }
    


}
