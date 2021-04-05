//
//  MainViewController.swift
//  GamerTrivia
//
//  Created by Jonathan Perz on 4/2/21.
//

import UIKit
import SwiftUI
import AVFoundation

class MainViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?

    @IBAction func insertCoin() {
        playSound(soundToPlay: "insertCoin")
        let vc = storyboard?.instantiateViewController(identifier: "genre") as! CategoryViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground()
        
    }
    
    private func playSound (soundToPlay: String) {
        let pathToSound = Bundle.main.path(forResource: soundToPlay, ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let err {
            print("Could not find sound filel", err)
        }
    }
}
