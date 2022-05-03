//
//  GameViewController.swift
//  Oxygen
//
//  Created by Y3858230 on 12/11/2019.
//  Copyright © 2019 Y3858230. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AudioKit

class GameViewController: UIViewController {
    
    // Create global variable for the GameScene class
    var currentGame: GameScene!

    // Storyboard Outlets //
    
    // Views //
    
    @IBOutlet var menuPannel: UIView!
    @IBOutlet var backgroundSettingsPannel: UIView!
    @IBOutlet var oscillatorControlPannel: UIView!
    @IBOutlet var informationTextPannel: UIView!
    @IBOutlet var themesPannel: UIView!

    // Buttons //
    
    @IBOutlet var optionsButton: UIButton!
    @IBOutlet var viewBackgroundSettingsButton: UIButton!
    @IBOutlet var hideBackgroundSettingsButton: UIButton!
    @IBOutlet var viewOscollatorSettingsButton: UIButton!
    @IBOutlet var hideOscillatorSettingsButton: UIButton!
    @IBOutlet var showInformationButton: UIButton!
    @IBOutlet var hideInformationButton: UIButton!
    @IBOutlet var hideThemesPannelButton: UIButton!
    @IBOutlet var resetSettingsButton: UIButton!
    
    // Labels //

    @IBOutlet var reverbTypeLabel: UILabel!
    
    // Sliders //
    
    @IBOutlet var delayTimeSlider: UISlider!
    @IBOutlet var delayFeedbackSlider: UISlider!
    @IBOutlet var delayDryWetMixSlider: UISlider!
    @IBOutlet var tremoloRateSlider: UISlider!
    @IBOutlet var tremoloDepthSlider: UISlider!
    @IBOutlet var dryWetMixSlider: UISlider!
    @IBOutlet var rampDurationSlider: UISlider!
    @IBOutlet var rainforestSoundsSlider: UISlider!
    @IBOutlet var oceanWaveSoundsSlider: UISlider!
    @IBOutlet var duskMusicSlider: UISlider!
    @IBOutlet var forestSoundsSlider: UISlider!
    @IBOutlet var rainSoundsSlider: UISlider!
    @IBOutlet var caveSoundsSlider: UISlider!
    @IBOutlet var daybreakMusicSlider: UISlider!
    
    
    // Switches //
    
    @IBOutlet var rainforestSoundsSwitch: UISwitch!
    @IBOutlet var oceanWaveSoundsSwitch: UISwitch!
    @IBOutlet var duskMusicSwitch: UISwitch!
    @IBOutlet var forestSoundsSwitch: UISwitch!
    @IBOutlet var rainSoundsSwitch: UISwitch!
    @IBOutlet var caveSoundsSwitch: UISwitch!
    @IBOutlet var daybreakMusicSwitch: UISwitch!
    
    
    // Segmented Controls //
    
    @IBOutlet var reverbTypeControl: UISegmentedControl!
    @IBOutlet var themeControl: UISegmentedControl!
    @IBOutlet var backgroundImageControl: UISegmentedControl!
    
    
    override func viewDidLoad() { // Runs just once at the start
        super.viewDidLoad()
        
        // Set up the game scene
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
               
                // Set the global variable as a game scene
                currentGame = scene as? GameScene
                currentGame.viewController = self // Can now interact with viewController by using self
                
                // Call function to set up view pannels
                setupPannels()
                
            }
            view.ignoresSiblingOrder = true
        }
    }

    // Storyboard Feature Functions //
    
    // Button Functions //
    
    // Function to show and hide the menu based on the tag of the menu button
    @IBAction func menuToggle(_ sender: UIButton) {
        // Condition to shift pannel onto display
        if optionsButton.tag == 1 {
            self.menuPannel.frame.origin.y -= 100  // Move pannel off screen
            menuPannel.isHidden = false            // Make pannel visible
            menuPannel.alpha = 1.0                 // Condition required to fade out later
            // Gradually move pannel down onto display
            UIView.animate(withDuration: 1.2, delay: 0.0, options: [],
                           animations: {self.menuPannel.frame.origin.y += 100},
                           completion: nil)
            optionsButton.setTitle("Hide Menu", for: UIControl.State.normal)
            optionsButton.tag = 2 // Needed to enable fade out action
        // Condition to fade pannel out of display
        } else {
            // Gradually fade pannel out
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut,
                           animations: { self.menuPannel.alpha = 0.0})
            optionsButton.setTitle("Show Menu", for: UIControl.State.normal)
            optionsButton.tag = 1 // Needed to enable fade in action
        }
    }
    
    // Function to move in the oscilattor controls gradually
    @IBAction func viewOscillatorSettings(_ sender: UIButton) {
        oscillatorControlPannel.alpha = 1.0 // Condition for fade
        self.oscillatorControlPannel.frame.origin.x -= 380 // Move pannel out of view
        oscillatorControlPannel.isHidden = false // Make pannel visible
        // Gradually move pannel onto display
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
                       animations: {self.oscillatorControlPannel.frame.origin.x += 380},
                       completion: nil)
    }
    
    // Function to fade out oscillator controls
    @IBAction func hideOscillatorSettings(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut,
                       animations: { self.oscillatorControlPannel.alpha = 0.0})
    }
    
    // Function to show the information about the application
    @IBAction func showApplicationInformation(_ sender: UIButton) {
        informationTextPannel.alpha = 0.0 // Required for fade in
        informationTextPannel.isHidden = false // Make visible
        // Fade in gradually
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn,
                       animations: { self.informationTextPannel.alpha = 1.0})
    }
    
    // Function to hide the applilcation information
    @IBAction func hideApplicationInformation(_ sender: UIButton) {
        informationTextPannel.alpha = 1.0 // Fade out condition
        // Fade out gradually
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut,
                       animations: { self.informationTextPannel.alpha = 0.0})
    }
    
    // Function to show the theme options
    @IBAction func showThemes(_ sender: UIButton) {
        themesPannel.alpha = 1.0 // Fade out condition
        self.themesPannel.frame.origin.x += 380
        themesPannel.isHidden = false
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
                       animations: {self.themesPannel.frame.origin.x -= 380},
                       completion: nil)
    }
    
    // Function to hide the theme options
    @IBAction func hideThemes(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut,
                       animations: { self.themesPannel.alpha = 0.0})
    }
    
    
    // Function to view the background controls for the application
    @IBAction func viewBackgroundSettings(_ sender: UIButton) {
        backgroundSettingsPannel.alpha = 1.0 // Fade out condition
        self.backgroundSettingsPannel.frame.origin.x += 380 // Move pannel off-screen
        backgroundSettingsPannel.isHidden = false // Make sure pannel is visible before animation
        // Move pannel onto display
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
                       animations: {self.backgroundSettingsPannel.frame.origin.x -= 380},
                       completion: nil)
    }
    
    // Function to fade out the background controls
    @IBAction func hideBackgroundSettings(_ sender: UIButton) {
        // Fade view out
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut,
                       animations: { self.backgroundSettingsPannel.alpha = 0.0})
    }
    
    
    // Function to reset all settings back to default (rainforest theme)
    @IBAction func resetSettingsToDefault(_ sender: UIButton) {
        // Remove all animations and images from display
        self.currentGame.removeAllChildren()
        
        // Change interface controls //
        
        themeControl.selectedSegmentIndex = 0
        
        // Oscillator Controls //
        
        // Delay controls
        delayTimeSlider.value = 0.6
        delayFeedbackSlider.value = 0.5
        delayDryWetMixSlider.value = 0.25
        
        // Reverb
        reverbTypeControl.selectedSegmentIndex = 0
        reverbTypeLabel.text = "Cathedral"
        dryWetMixSlider.value = 0.85
        self.currentGame.audioLibrary.selectFirstReverbPreset()
        
        // Tremolo
        tremoloRateSlider.value = 0.1
        tremoloDepthSlider.value = 0.4
        
        // Ramp Time
        rampDurationSlider.value = 0.95
        
        // Background Controls //
        
        // Enivronment
        backgroundImageControl.selectedSegmentIndex = 0
        self.currentGame.selectForestBackground()
        
        // Sounds
        rainforestSoundsSwitch.isOn = true
        oceanWaveSoundsSwitch.isOn = false
        duskMusicSwitch.isOn = false
        forestSoundsSwitch.isOn = true
        rainSoundsSwitch.isOn = true
        caveSoundsSwitch.isOn = false
        daybreakMusicSwitch.isOn = false
        
        rainforestSoundsSlider.value = 1.0
        oceanWaveSoundsSlider.value = 0.5
        duskMusicSlider.value = 0.5
        forestSoundsSlider.value = 0.4
        rainSoundsSlider.value = 0.7
        caveSoundsSlider.value = 0.5
        daybreakMusicSlider.value = 0.5
        
        // Update controls
        updateControlsFromInterface()
    }
    
    
    // Segmented Control Functions //
    
    // Function to select which image to set as application background
    @IBAction func selectBackgroundImage(_ sender: UISegmentedControl) {
        
        // Set corresponding environment background from selected segment
        switch backgroundImageControl.selectedSegmentIndex {
        case 0:
            self.currentGame.selectForestBackground()
        case 1:
            self.currentGame.selectCaveBackground()
        case 2:
            self.currentGame.selectSpaceBackground()
        case 3:
            self.currentGame.selectSunsetBackground()
        case 4:
            self.currentGame.selectRavineBackground()
        default:
            break
        }
    }
    
    // Function to select reverb preset using a segmented control
    @IBAction func selectReverbSetting(_ sender: UISegmentedControl) {
        
        switch reverbTypeControl.selectedSegmentIndex {
        case 0:
            self.currentGame.audioLibrary.selectFirstReverbPreset()
            reverbTypeLabel.text = "Cathedral"
        case 1:
            self.currentGame.audioLibrary.selectSecondReverbPreset()
            reverbTypeLabel.text = "Plate"
        case 2:
            self.currentGame.audioLibrary.selectThirdReverbPreset()
            reverbTypeLabel.text = "Medium Chamber"
        case 3:
            self.currentGame.audioLibrary.selectFourthReverbPreset()
            reverbTypeLabel.text = "Small Room"
        case 4:
            self.currentGame.audioLibrary.selectFifthReverbPreset()
            reverbTypeLabel.text = "Large Hall"
        case 5:
            self.currentGame.audioLibrary.selectSixthReverbPreset()
            reverbTypeLabel.text = "Large Chamber"
        default:
            break
        }
    }
    
    // Function to transform interface into different themes
    @IBAction func selectTheme(_ sender: UISegmentedControl) {
        switch themeControl.selectedSegmentIndex {
            
        // Forest theme
        case 0:
            
            // Remove all current background & animations
            self.currentGame.removeAllChildren()
            
            // Add animation nodes
            self.currentGame.addRainNodes()
            
            // Change interface controls //
            
            // Oscillator Controls //
            
            // Delay
            delayTimeSlider.value = 0.6
            delayFeedbackSlider.value = 0.5
            delayDryWetMixSlider.value = 0.25
            
            // Reverb
            reverbTypeControl.selectedSegmentIndex = 0
            reverbTypeLabel.text = "Cathedral"
            dryWetMixSlider.value = 0.85
            self.currentGame.audioLibrary.selectFirstReverbPreset()
            
            // Tremolo
            tremoloRateSlider.value = 0.1
            tremoloDepthSlider.value = 0.4
            
            // Ramp Time
            rampDurationSlider.value = 0.95
            
            // Background Controls //
            
            // Enivronment
            backgroundImageControl.selectedSegmentIndex = 0
            self.currentGame.selectForestBackground()
            
            // Sounds //
            
            // On/Off switches
            rainforestSoundsSwitch.isOn = true
            oceanWaveSoundsSwitch.isOn = false
            duskMusicSwitch.isOn = false
            forestSoundsSwitch.isOn = true
            rainSoundsSwitch.isOn = true
            caveSoundsSwitch.isOn = false
            daybreakMusicSwitch.isOn = false
            
            // Volume
            rainforestSoundsSlider.value = 1.0
            oceanWaveSoundsSlider.value = 0.5
            duskMusicSlider.value = 0.5
            forestSoundsSlider.value = 0.4
            rainSoundsSlider.value = 0.7
            caveSoundsSlider.value = 0.5
            daybreakMusicSlider.value = 0.5
            
            // Update controls
            updateControlsFromInterface()
        
        // Cavern Theme
        case 1:
            
            // Remove all current background & animations
            self.currentGame.removeAllChildren()
            
            // Add animation node
            self.currentGame.addCaveNode()
            
            // Change interface controls //
            
            // Oscillator Controls //
            
            // Delay
            delayTimeSlider.value = 0.2
            delayFeedbackSlider.value = 0.7
            delayDryWetMixSlider.value = 0.6
            
            // Reverb
            reverbTypeControl.selectedSegmentIndex = 4
            reverbTypeLabel.text = "Large Hall"
            dryWetMixSlider.value = 0.6
            self.currentGame.audioLibrary.selectFifthReverbPreset()
            
            // Tremolo
            tremoloRateSlider.value = 0.8
            tremoloDepthSlider.value = 0.2
            
            // Ramp Time
            rampDurationSlider.value = 0.15
            
            // Background Controls //
            
            // Enivronment
            backgroundImageControl.selectedSegmentIndex = 1
            self.currentGame.selectCaveBackground()
            
            // Sounds  //
            
            // On/Off switches
            rainforestSoundsSwitch.isOn = false
            oceanWaveSoundsSwitch.isOn = false
            duskMusicSwitch.isOn = false
            forestSoundsSwitch.isOn = false
            rainSoundsSwitch.isOn = false
            caveSoundsSwitch.isOn = true
            daybreakMusicSwitch.isOn = false
            
            // ~Volume
            rainforestSoundsSlider.value = 0.5
            oceanWaveSoundsSlider.value = 0.5
            duskMusicSlider.value = 0.5
            forestSoundsSlider.value = 0.5
            rainSoundsSlider.value = 0.5
            caveSoundsSlider.value = 1.0
            daybreakMusicSlider.value = 0.5
            
            // Update controls
            updateControlsFromInterface()
            
        // Space Theme
        case 2:
            
            // Remove all current background & animations
            self.currentGame.removeAllChildren()
            
            // Add animation nodes
            self.currentGame.addSpaceNodes()
            
            // Change interface controls //
            
            // Oscillator Controls //
            
            // Delay
            delayTimeSlider.value = 0.1
            delayFeedbackSlider.value = 0.4
            delayDryWetMixSlider.value = 0.2
            
            // Reverb
            reverbTypeControl.selectedSegmentIndex = 1
            dryWetMixSlider.value = 0.7
            reverbTypeLabel.text = "Plate"
            self.currentGame.audioLibrary.selectSecondReverbPreset()
            
            // Tremolo
            tremoloRateSlider.value = 0.8
            tremoloDepthSlider.value = 0.75
            
            // Ramp Time
            rampDurationSlider.value = 0.15
            
            // Background Controls //
            
            // Enivronment
            backgroundImageControl.selectedSegmentIndex = 2
            self.currentGame.selectSpaceBackground()
            
            // Sounds //
            
            // On/Off switches
            rainforestSoundsSwitch.isOn = false
            oceanWaveSoundsSwitch.isOn = false
            duskMusicSwitch.isOn = true
            forestSoundsSwitch.isOn = false
            rainSoundsSwitch.isOn = false
            caveSoundsSwitch.isOn = false
            daybreakMusicSwitch.isOn = false
            
            // Volume
            rainforestSoundsSlider.value = 0.5
            oceanWaveSoundsSlider.value = 0.5
            duskMusicSlider.value = 1.0
            forestSoundsSlider.value = 0.5
            rainSoundsSlider.value = 0.5
            caveSoundsSlider.value = 0.5
            daybreakMusicSlider.value = 0.5
            
            // Update controls
            updateControlsFromInterface()
            
        // Sunset Theme
        case 3:
            
            // Remove all current background & animations
            self.currentGame.removeAllChildren()
            
            // Add animation node
            self.currentGame.addSunsetNode()
            
            // Change interface controls //
            
            // Oscillator Controls //
            
            // Delay
            delayTimeSlider.value = 0.7
            delayFeedbackSlider.value = 0.3
            delayDryWetMixSlider.value = 0.15
            
            // Reverb
            reverbTypeControl.selectedSegmentIndex = 5
            dryWetMixSlider.value = 0.65
            reverbTypeLabel.text = "Large Chamber"
            self.currentGame.audioLibrary.selectSixthReverbPreset()
            
            // Tremolo
            tremoloRateSlider.value = 0.1
            tremoloDepthSlider.value = 0.1
            
            // Ramp Time
            rampDurationSlider.value = 0.8
            
            // Background Controls //
            
            // Enivronment
            backgroundImageControl.selectedSegmentIndex = 3
            self.currentGame.selectSunsetBackground()
            
            // Sounds //
            
            // On/Off Swiches
            rainforestSoundsSwitch.isOn = false
            oceanWaveSoundsSwitch.isOn = true
            duskMusicSwitch.isOn = false
            forestSoundsSwitch.isOn = false
            rainSoundsSwitch.isOn = false
            caveSoundsSwitch.isOn = false
            daybreakMusicSwitch.isOn = true
            
            // Volume
            rainforestSoundsSlider.value = 0.5
            oceanWaveSoundsSlider.value = 0.6
            duskMusicSlider.value = 0.5
            forestSoundsSlider.value = 0.5
            rainSoundsSlider.value = 0.5
            caveSoundsSlider.value = 0.5
            daybreakMusicSlider.value = 1.0
            
            // Update controls
            updateControlsFromInterface()
            
        // Ravine Theme
        case 4:
            
            // Remove all current background & animations
            self.currentGame.removeAllChildren()
            
            // Add animation node
            self.currentGame.addRavineNode()
            
            // Change interface controls //
            
            // Oscillator Controls //
            
            // Delay
            delayTimeSlider.value = 0.8
            delayFeedbackSlider.value = 0.5
            delayDryWetMixSlider.value = 0.65
            
            // Reverb
            reverbTypeControl.selectedSegmentIndex = 4
            dryWetMixSlider.value = 0.4
            reverbTypeLabel.text = "Large Hall"
            self.currentGame.audioLibrary.selectSecondReverbPreset()
            
            // Tremolo
            tremoloRateSlider.value = 4
            tremoloDepthSlider.value = 0.9
            
            // Ramp Time
            rampDurationSlider.value = 0.2
            
            // Background Controls //
            
            // Enivronment
            backgroundImageControl.selectedSegmentIndex = 4
            self.currentGame.selectRavineBackground()
            
            // Sounds //
            
            // On/Off switches
            rainforestSoundsSwitch.isOn = false
            oceanWaveSoundsSwitch.isOn = false
            duskMusicSwitch.isOn = false
            forestSoundsSwitch.isOn = true
            rainSoundsSwitch.isOn = false
            caveSoundsSwitch.isOn = false
            daybreakMusicSwitch.isOn = false
            
            // Volume
            rainforestSoundsSlider.value = 0.5
            oceanWaveSoundsSlider.value = 0.5
            duskMusicSlider.value = 0.5
            forestSoundsSlider.value = 1.0
            rainSoundsSlider.value = 0.5
            caveSoundsSlider.value = 0.5
            daybreakMusicSlider.value = 0.5
            
            // Update controls
            updateControlsFromInterface()
            
        default:
            break
        }
    }
    
    
    
    // Slider Functions //
    
    
    // Functions to change an audio effect based off it's corresponding slider value //
    
    // Reverb //
    
    @IBAction func setReverbDryWetMix(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeReverbDryWetMix(dryWetMixSlider.value)
    }
    
    // Delay //
    
    @IBAction func setDelayTime(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeDelayTime(delayTimeSlider.value) 
    }
    
    @IBAction func setDelayFeedbackAmount(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeDelayFeedbackAmount(delayFeedbackSlider.value)
    }
    
    @IBAction func setDelayDryWetMix(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeDelayDryWetMix(delayDryWetMixSlider.value)
    }
    
    // Tremolo //
    
    @IBAction func setTremoloRate(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeTremoloRate(tremoloRateSlider.value)
    }
    
    @IBAction func setTremoloDepth(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeTremoloDepth(tremoloDepthSlider.value)
    }
    
    // Ramp Duration //
    
    @IBAction func changeRampDuration(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeRampDuration(rampDurationSlider.value)
    }
    
    
    // Functions to change the volume of the background sound files based on their slider values //
    
    @IBAction func changeRainforestSoundsVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeRainforestSoundsVolume(rainforestSoundsSlider.value)
    }
    
    @IBAction func changeOceanSoundsVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeOceanWaveSoundsVolume(oceanWaveSoundsSlider.value)
    }
    
    @IBAction func changeDuskMusicVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeDuskMusicVolume(duskMusicSlider.value)
    }
    
    @IBAction func changeForestSoundsVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeRavineSoundsVolume(forestSoundsSlider.value)
    }
    
    @IBAction func changeRainSoundsVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeRainSoundsVolume(rainSoundsSlider.value)
    }
    
    @IBAction func changeCaveSoundsVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeCaveSoundsVolume(caveSoundsSlider.value)
    }
    
    @IBAction func changeDaybreakMusicVolume(_ sender: UISlider) {
        self.currentGame.audioLibrary.changeDaybreakMusicVolume(daybreakMusicSlider.value)
    }
    
    
    
    // Switch Fucntions //
    
    // Functions to toggle the background sound files on and off using a switch //
    
    @IBAction func toggleRainforestSounds(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startRainforestSoundsPlaying()
        } else {
            self.currentGame.audioLibrary.stopRainforestSoundsPlaying()
        }
    }
    
    @IBAction func toggleOceanWaveSounds(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startOceanWaveSoundsPlaying()
        } else {
            self.currentGame.audioLibrary.stopOceanWaveSoundsPlaying()
        }
    }
    
    @IBAction func toggleDuskMusic(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startDuskMusicPlaying()
        } else {
            self.currentGame.audioLibrary.stopDuskMusicPlaying()
        }
    }
    
    @IBAction func toggleForestSounds(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startRavineSoundsPlaying()
        } else {
            self.currentGame.audioLibrary.stopRavineSoundsPlaying()
        }
    }
    
    @IBAction func toggleRainSounds(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startRainSoundsPlaying()
        } else {
            self.currentGame.audioLibrary.stopRainSoundsPlaying()
        }
    }
    
    @IBAction func toggleCaveSounds(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startCaveSoundsPlaying()
        } else {
            self.currentGame.audioLibrary.stopCaveSoundsPlaying()
        }
    }
    
    @IBAction func toggleDaybreakMusic(_ sender: UISwitch) {
        if sender.isOn == true {
            self.currentGame.audioLibrary.startDaybreakMusicPlaying()
        } else {
            self.currentGame.audioLibrary.stopDaybreakMusicPlaying()
        }
    }
    
    
    
    // Function to set initial conditions for each pannel on the main display
    open func setupPannels() {
        // Initially hide all pannels
        backgroundSettingsPannel.isHidden = true
        menuPannel.isHidden = true
        themesPannel.isHidden = true
        oscillatorControlPannel.isHidden = true
        informationTextPannel.isHidden = true
        
        // Make edges round for each pannel
        backgroundSettingsPannel.layer.cornerRadius = 15
        menuPannel.layer.cornerRadius = 10
        themesPannel.layer.cornerRadius = 10
        oscillatorControlPannel.layer.cornerRadius = 15
        informationTextPannel.layer.cornerRadius = 15
        
        // Set to display
        backgroundSettingsPannel.layer.masksToBounds = true
        menuPannel.layer.masksToBounds = true
        themesPannel.layer.masksToBounds = true
        oscillatorControlPannel.layer.masksToBounds = true
        informationTextPannel.layer.masksToBounds = true
    }

    // Function to assign the current states of all interface controls
    open func updateControlsFromInterface() {
        // Oscillator Controls //
        
        // Delay
        self.currentGame.audioLibrary.changeDelayTime(delayTimeSlider.value)
        self.currentGame.audioLibrary.changeDelayFeedbackAmount(delayFeedbackSlider.value)
        self.currentGame.audioLibrary.changeDelayDryWetMix(delayDryWetMixSlider.value)
        
        // Reverb
        self.currentGame.audioLibrary.changeReverbDryWetMix(dryWetMixSlider.value)
        
        // Tremolo
        self.currentGame.audioLibrary.changeTremoloRate(tremoloRateSlider.value)
        self.currentGame.audioLibrary.changeTremoloDepth(tremoloDepthSlider.value)
        
        // Ramp Time
        self.currentGame.audioLibrary.changeRampDuration(rampDurationSlider.value)
        
        // Background Sounds //
        
        // Volume
        self.currentGame.audioLibrary.changeRainforestSoundsVolume(rainforestSoundsSlider.value)
        self.currentGame.audioLibrary.changeOceanWaveSoundsVolume(oceanWaveSoundsSlider.value)
        self.currentGame.audioLibrary.changeDuskMusicVolume(duskMusicSlider.value)
        self.currentGame.audioLibrary.changeRavineSoundsVolume(forestSoundsSlider.value)
        self.currentGame.audioLibrary.changeRainSoundsVolume(rainSoundsSlider.value)
        self.currentGame.audioLibrary.changeCaveSoundsVolume(caveSoundsSlider.value)
        self.currentGame.audioLibrary.changeDaybreakMusicVolume(daybreakMusicSlider.value)
        
        // Playing condition
        toggleRainforestSounds(rainforestSoundsSwitch)
        toggleOceanWaveSounds(oceanWaveSoundsSwitch)
        toggleDuskMusic(duskMusicSwitch)
        toggleForestSounds(forestSoundsSwitch)
        toggleRainSounds(rainSoundsSwitch)
        toggleCaveSounds(caveSoundsSwitch)
        toggleDaybreakMusic(daybreakMusicSwitch)
    }
    
    
    // Preset Functions //
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
