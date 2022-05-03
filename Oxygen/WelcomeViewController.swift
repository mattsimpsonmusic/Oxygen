//
//  WelcomeViewController.swift
//  Oxygen
//
//  Created by Y3858230 on 08/12/2019.
//  Copyright © 2019 Y3858230. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {
    
    // Instantiate variables for each audio player
    var introMusicPlayer = AVAudioPlayer()
    var buttonSoundPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create audio players based on their corresponding sound filles
        let introSound = Bundle.main.path(forResource: "introScreen", ofType: "wav")
        let buttonSound = Bundle.main.path(forResource: "welcomeToGame", ofType: "wav")
        
        // Try to assign each sound file to its audio player
        do {
            introMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: introSound!))
        } catch {
            // Print an error if unsuccessful
            print(error)
        }
        
        do {
            buttonSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: buttonSound!))
        } catch {
            // Print an error if unsuccessful
            print(error)
        }
        
        
        // Play the first audio player
        introMusicPlayer.play()
    }
    
    // When a button is pressed, stop the intro music and play the welcome sound
    @IBAction func introButtonPressed(_ sender: UIButton) {
        introMusicPlayer.stop()
        buttonSoundPlayer.play()
    }
}
