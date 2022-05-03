//
//  AudioEngine.swift
//  Oxygen 
//
//  Created by Y3858230 on 14/11/2019.
//  Copyright © 2019 Y3858230. All rights reserved.
//

import UIKit
import AudioKit
import SoundpipeAudioKit

open class MainAudioEngine {
    
    // Create variables for each oscillator
    var oscillator1: FMOscillator!
    var oscillator2: FMOscillator!
    var oscillator3: FMOscillator!
    var oscillator4: FMOscillator!
    var oscillator5: FMOscillator!
    
    // Create amplitude envelopes for each oscillator
    var adsr1: AmplitudeEnvelope!
    var adsr2: AmplitudeEnvelope!
    var adsr3: AmplitudeEnvelope!
    var adsr4: AmplitudeEnvelope!
    var adsr5: AmplitudeEnvelope!

    // Create effects units
    var reverb: Reverb!
    var delay: Delay!
    var tremolo: Tremolo!
    
    // Create variables for each audio player
    var caveSounds: AudioPlayer!
    var daybreakMusic: AudioPlayer!
    var duskMusic: AudioPlayer!
    var oceanWaveSounds: AudioPlayer!
    var rainSounds: AudioPlayer!
    var rainforestSounds: AudioPlayer!
    var ravineSounds: AudioPlayer!
    
    // Create structures to store the 2D coordinates of each touch
    var oscillator1Location: CGPoint?
    var oscillator2Location: CGPoint?
    var oscillator3Location: CGPoint?
    var oscillator4Location: CGPoint?
    var oscillator5Location: CGPoint?
    
    // Initialize oscillator parameters
    var oscAmplitude = 0.3
    var oscFrequency = 440.0 // A4
    var oscRampTime = 0.7
    
    // Create conditions for the ADSR units
    var attackAmount = 0.1
    var decayAmount = 0.1
    var sustainAmount = 0.5
    var releaseAmount = 0.1
   
    
    init() { // Runs once when class is first instantiated
        
        // Set up the 5 oscillators and their ADSR units
        setUpAllOscillators()
        
        // Create constant to store mixed output of background music files
        let backgroundMix = setUpBackgroundSounds()
        
        // Create constant to store mixed output of all ADSR units
        let oscillatorMix = Mixer(adsr1, adsr2, adsr3, adsr4, adsr5)
        

        // Set up reverb unit and initialise parameters
        reverb = Reverb(oscillatorMix) // Attatch to ADSR mix
        reverb.dryWetMix = 0.85
        reverb.loadFactoryPreset(.cathedral)
        
        // Set up tremolo unit and initialise parameters
        tremolo = Tremolo(oscillatorMix) // Attatch to ADSR mix
        tremolo.frequency = 0.1
        tremolo.depth = 0.4
    
        
        // Create constant to store mixed output of both audio effect units
        let effectsMix = Mixer(reverb, tremolo)
        
        // Set up delay unit and initialise parameters
        delay = Delay(effectsMix) // Attatch to all mixed effects
        delay.dryWetMix = 0.25
        delay.feedback = 0.5
        delay.time = 0.6
        
        // Create mixer to mic processed effect unit with background music
        let outputMix = Mixer(backgroundMix, delay)
        
        // Connect all sounds to output
        var engine = AudioEngine()
        engine.output = outputMix
        try!outputMix.start() // Start the AudioKit audio-engine

        // Start rainforest environment music
        rainforestSounds.start()
        rainSounds.volume = 0.7
        rainSounds.start()
    }
    
    
    // This function is called by the view controller to start and stop the oscillator
    open func start(currentPosition: CGPoint) {
        // Start all oscillators
        oscillator1.start()
        oscillator2.start()
        oscillator3.start()
        oscillator4.start()
        oscillator5.start()
        
        // Adjust values of pitch and reverb based on current position
        controlXParameter(posititon: currentPosition)
        controlYParameter(position: currentPosition)
        
        // Search through each ADSR unit and play the next one that wasn't already playing
        // Update the audio effects an position of each oscillator
        
        if adsr1.isStarted == false{
            oscillator1.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator1.amplitude = AUValue(oscAmplitude)
            oscillator1.baseFrequency = AUValue(oscFrequency)
            oscillator1Location = currentPosition
            adsr1.start()
            
        }
        else if adsr2.isStarted == false {
            oscillator2.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator2.amplitude = AUValue(oscAmplitude)
            oscillator2.baseFrequency = AUValue(oscFrequency)
            oscillator2Location = currentPosition
            adsr2.start()
        }
        else if adsr3.isStarted == false {
            oscillator3.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator3.amplitude = AUValue(oscAmplitude)
            oscillator3.baseFrequency = AUValue(oscFrequency)
            oscillator3Location = currentPosition
            adsr3.start()
        }
        else if adsr4.isStarted == false {
            oscillator4.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator4.amplitude = AUValue(oscAmplitude)
            oscillator4.baseFrequency = AUValue(oscFrequency)
            oscillator4Location = currentPosition
            adsr4.start()
        }
        else if adsr5.isStarted == false {
            oscillator5.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator5.amplitude = AUValue(oscAmplitude)
            oscillator5.baseFrequency = AUValue(oscFrequency)
            oscillator5Location = currentPosition
            adsr5.start()
        }
    }
    
    // Function to update the oscillators when a touch is moved
    open func update(currentPosition: CGPoint, newPosition: CGPoint) {
        // Adjust values of pitch and reverb based on current position
        controlXParameter(posititon: newPosition)
        controlYParameter(position: newPosition)
        
        // If the current position is the same as one of the oscillators
        // Update the parameters of that oscillator based on its location
        
        if currentPosition == oscillator1Location {
            oscillator1.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator1.amplitude = AUValue(oscAmplitude)
            oscillator1.baseFrequency = AUValue(oscFrequency)
            oscillator1Location = newPosition
        }
        else if currentPosition == oscillator2Location {
            oscillator2.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator2.amplitude = AUValue(oscAmplitude)
            oscillator2.baseFrequency = AUValue(oscFrequency)
            oscillator2Location = newPosition
        }
        else if currentPosition == oscillator3Location {
            oscillator3.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator3.amplitude = AUValue(oscAmplitude)
            oscillator3.baseFrequency = AUValue(oscFrequency)
            oscillator3Location = newPosition
        }
        else if currentPosition == oscillator4Location {
            oscillator4.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator4.amplitude = AUValue(oscAmplitude)
            oscillator4.baseFrequency = AUValue(oscFrequency)
            oscillator4Location = newPosition
        }
        else if currentPosition == oscillator5Location {
            oscillator5.$amplitude.ramp(from: 1, to: 5, duration: Float(oscRampTime))
            oscillator5.amplitude = AUValue(oscAmplitude)
            oscillator5.baseFrequency = AUValue(oscFrequency)
            oscillator5Location = newPosition
        }
        
        
    }

    // Function to stop the sound of an oscillator when a touch is released
    open func stop(currentPosition: CGPoint, newPosition: CGPoint) {
        // If the oscillator position is the same as the touch
        // Stop the oscillator and nullify the oscillator's location
        
        if currentPosition == oscillator1Location || newPosition == oscillator1Location {
            adsr1.stop()
            oscillator1.amplitude = 0.0
            oscillator1Location = nil
        }
        else if currentPosition == oscillator2Location || newPosition == oscillator2Location {
            adsr2.stop()
            oscillator2.amplitude = 0.0
            oscillator2Location = nil
        }
        else if currentPosition == oscillator3Location || newPosition == oscillator3Location {
            adsr3.stop()
            oscillator3.amplitude = 0.0
            oscillator3Location = nil
        }
        else if currentPosition == oscillator4Location || newPosition == oscillator4Location {
            adsr4.stop()
            oscillator4.amplitude = 0.0
            oscillator4Location = nil
        }
        else if currentPosition == oscillator5Location || newPosition == oscillator5Location {
            adsr5.stop()
            oscillator5.amplitude = 0.0
            oscillator5Location = nil
        }
    }
    
    
    // Setup Functions //
    
    // Function to set up each oscillator and amplitude envelope
    func setUpAllOscillators() {
        // Set up oscillators
        if oscillator1 == nil {
            oscillator1 = FMOscillator()
            oscillator1.start()
            oscillator1.amplitude = AUValue(oscAmplitude)
            oscillator1.baseFrequency = AUValue(oscFrequency)
        }
        // Create amplitude envelope
        if adsr1 == nil {
            adsr1 = AmplitudeEnvelope(oscillator1)
            adsr1.stop()
        }
        
        // Assign envolope values to global variables
        adsr1.attackDuration = AUValue(attackAmount)
        adsr1.decayDuration = AUValue(decayAmount)
        adsr1.sustainLevel = AUValue(sustainAmount)
        adsr1.releaseDuration = AUValue(releaseAmount)
        
        // Set up oscillator
        if oscillator2 == nil {
            oscillator2 = FMOscillator()
            oscillator2.start()
            oscillator2.amplitude = AUValue(oscAmplitude)
            oscillator2.baseFrequency = AUValue(oscFrequency)
        }
        // Create amplitude envelope
        if adsr2 == nil {
            adsr2 = AmplitudeEnvelope(oscillator2)
            adsr2.stop()
        }
        
        // Assign envolope values to global variables
        adsr2.attackDuration = AUValue(attackAmount)
        adsr2.decayDuration = AUValue(decayAmount)
        adsr2.sustainLevel = AUValue(sustainAmount)
        adsr2.releaseDuration = AUValue(releaseAmount)
        
        // Set up oscillator
        if oscillator3 == nil {
            oscillator3 = FMOscillator()
            oscillator3.start()
            oscillator3.amplitude = AUValue(oscAmplitude)
            oscillator3.baseFrequency = AUValue(oscFrequency)
        }
        // Create amplitude envelope
        if adsr3 == nil {
            adsr3 = AmplitudeEnvelope(oscillator3)
            adsr3.stop()
        }
        
        // Assign envolope values to global variables
        adsr3.attackDuration = AUValue(attackAmount)
        adsr3.decayDuration = AUValue(decayAmount)
        adsr3.sustainLevel = AUValue(sustainAmount)
        adsr3.releaseDuration = AUValue(releaseAmount)
        
        // Set up oscillator
        if oscillator4 == nil {
            oscillator4 = FMOscillator()
            oscillator4.start()
            oscillator4.amplitude = AUValue(oscAmplitude)
            oscillator4.baseFrequency = AUValue(oscFrequency)
        }
        // Create amplitude envelope
        if adsr4 == nil {
            adsr4 = AmplitudeEnvelope(oscillator4)
            adsr4.stop()
        }
        
        // Assign envolope values to global variables
        adsr4.attackDuration = AUValue(attackAmount)
        adsr4.decayDuration = AUValue(decayAmount)
        adsr4.sustainLevel = AUValue(sustainAmount)
        adsr4.releaseDuration = AUValue(releaseAmount)
        
        // Set up oscillator
        if oscillator5 == nil {
            oscillator5 = FMOscillator()
            oscillator5.start()
            oscillator5.amplitude = AUValue(oscAmplitude)
            oscillator5.baseFrequency = AUValue(oscFrequency)
        }
        // Create amplitude envelope
        if adsr5 == nil {
            adsr5 = AmplitudeEnvelope(oscillator5)
            adsr5.stop()
        }
        
        // Assign envolope values to global variables
        adsr5.attackDuration = AUValue(attackAmount)
        adsr5.decayDuration = AUValue(decayAmount)
        adsr5.sustainLevel = AUValue(sustainAmount)
        adsr5.releaseDuration = AUValue(releaseAmount)
    }
    
    
    // Function to set up the background sound files and return a mixed output
    func setUpBackgroundSounds() -> Mixer {
        // Load in each sound file
        // See README.txt for sound file copyright information
        let caveSoundsFile = Bundle.main.path(forResource: "cave.wav", ofType: nil)!
        let daybreakPianoMusicFile = Bundle.main.path(forResource: "daybreakOriginal.wav", ofType: nil)!
        let duskPianoMusicFile = Bundle.main.path(forResource: "duskOriginal.wav", ofType: nil)!
        let oceanWaveSoundsFile = Bundle.main.path(forResource: "oceanWaves.wav", ofType: nil)!
        let rainSoundsFile = Bundle.main.path(forResource: "rain.wav", ofType: nil)!
        let rainforestSoundsFile = Bundle.main.path(forResource: "rainforest.wav", ofType: nil)!
        let ravineSoundsFile = Bundle.main.path(forResource: "ravine.wav", ofType: nil)!
        
        // Link to player by defining URL location
        let caveSoundsURL = URL(fileURLWithPath: caveSoundsFile)
        let daybreakPianoMusicURL = URL(fileURLWithPath: daybreakPianoMusicFile)
        let duskPianoMusicURL = URL(fileURLWithPath: duskPianoMusicFile)
        let oceanWaveSoundsURL = URL(fileURLWithPath: oceanWaveSoundsFile)
        let rainSoundsURL = URL(fileURLWithPath: rainSoundsFile)
        let rainforestSoundsURL = URL(fileURLWithPath: rainforestSoundsFile)
        let ravineSoundsURL = URL(fileURLWithPath: ravineSoundsFile)
        
        
        // Assign audio players to each audio file
        caveSounds = AudioPlayer(url: caveSoundsURL)
        daybreakMusic = AudioPlayer(url: daybreakPianoMusicURL)
        duskMusic = AudioPlayer(url: duskPianoMusicURL)
        oceanWaveSounds = AudioPlayer(url: oceanWaveSoundsURL)
        rainSounds = AudioPlayer(url: rainSoundsURL)
        rainforestSounds = AudioPlayer(url: rainforestSoundsURL)
        ravineSounds = AudioPlayer(url: ravineSoundsURL)
        
        // Loop each player
        caveSounds.isLooping = true
        daybreakMusic.isLooping = true
        duskMusic.isLooping = true
        oceanWaveSounds.isLooping = true
        rainSounds.isLooping = true
        rainforestSounds.isLooping = true
        ravineSounds.isLooping = true
        
        // Create a constant to mix all background tracks together
        let backgroundSoundsMix = Mixer(caveSounds, daybreakMusic, duskMusic, oceanWaveSounds,
                                          rainSounds, rainforestSounds, ravineSounds)
        
        // Return mixed output to user
        return backgroundSoundsMix
    
    }
    
    // Oscillator Control Functions //
    
    // Functions to change the amount of a particular effect based on a slider value
    // Note: ADSR controls not included on interface for simplicity's sake
    
    open func changeReverbDryWetMix(_ amount: Float) {
        reverb.dryWetMix = AUValue(Double(amount))
    }
    
    open func changeDelayTime(_ time: Float) {
        delay.time = AUValue(Double(time) * 1.5)
    }
    
    open func changeDelayFeedbackAmount(_ amount: Float) {
        delay.feedback = AUValue(Double(amount))
    }
    
    open func changeDelayDryWetMix(_ amount: Float) {
        delay.dryWetMix = AUValue(Double(amount))
    }
    
    open func changeTremoloRate(_ rate: Float) {
        tremolo.frequency = AUValue(Double(rate) * 20)
    }
    
    open func changeTremoloDepth(_ depth: Float) {
        tremolo.depth = AUValue(Double(depth))
    }
    
    open func changeRampDuration(_ time: Float) {
        oscRampTime = Double (time) * 1.4
    }
    
    // Functions to select a particular reverb preset

    open func selectFirstReverbPreset() {
        reverb.loadFactoryPreset(.cathedral)
    }
    
    open func selectSecondReverbPreset() {
        reverb.loadFactoryPreset(.plate)
    }
    
    open func selectThirdReverbPreset() {
        reverb.loadFactoryPreset(.mediumChamber)
    }
    
    open func selectFourthReverbPreset() {
        reverb.loadFactoryPreset(.smallRoom)
    }
    
    open func selectFifthReverbPreset() {
        reverb.loadFactoryPreset(.largeHall2)
    }
    
    open func selectSixthReverbPreset() {
        reverb.loadFactoryPreset(.largeChamber)
    }
    
    
    // Background Control Functions //
    
    
    // Functions to control the volume of each sound file using a slider
    
    open func changeCaveSoundsVolume(_ volume: Float) {
        caveSounds.volume = AUValue(Double(volume))
    }
    
    open func changeDaybreakMusicVolume(_ volume: Float) {
        daybreakMusic.volume = AUValue(Double(volume))
    }
    
    open func changeDuskMusicVolume(_ volume: Float) {
        duskMusic.volume = AUValue(Double(volume))
    }
    
    open func changeOceanWaveSoundsVolume(_ volume: Float) {
        oceanWaveSounds.volume = AUValue(Double(volume))
    }
    
    open func changeRainSoundsVolume(_ volume: Float) {
        rainSounds.volume = AUValue(Double(volume))
    }
    
    open func changeRainforestSoundsVolume(_ volume: Float) {
        rainforestSounds.volume = AUValue(Double(volume))
    }
    
    open func changeRavineSoundsVolume(_ volume: Float) {
        ravineSounds.volume = AUValue(Double(volume))
    }
    
    // Functions to start and stop each sound file (controlled by a switch)
    
    // To start
    
    open func startCaveSoundsPlaying() {
        caveSounds.start()
    }

    open func startDaybreakMusicPlaying() {
        daybreakMusic.start()
    }
    
    open func startDuskMusicPlaying() {
        duskMusic.start()
    }
    
    open func startOceanWaveSoundsPlaying() {
        oceanWaveSounds.start()
    }
    
    open func startRainSoundsPlaying() {
        rainSounds.start()
    }
    
    open func startRainforestSoundsPlaying() {
        rainforestSounds.start()
    }
    
    open func startRavineSoundsPlaying() {
        ravineSounds.start()
    }
    
    // To stop
    
    open func stopCaveSoundsPlaying() {
        caveSounds.stop()
    }
    
    open func stopDaybreakMusicPlaying() {
        daybreakMusic.stop()
    }
    
    open func stopDuskMusicPlaying() {
        duskMusic.stop()
    }
    
    open func stopOceanWaveSoundsPlaying() {
        oceanWaveSounds.stop()
    }
    
    open func stopRainSoundsPlaying() {
        rainSounds.stop()
    }
    
    open func stopRainforestSoundsPlaying() {
        rainforestSounds.stop()
    }
    
    open func stopRavineSoundsPlaying() {
        ravineSounds.stop()
    }
    
    
    
    // Function to take the current position of a touch and normalise its x and y values
    func convertCurrentLoaction(position: CGPoint) -> CGPoint {
        // Normalise values
        let x = (position.x / 1024 + 0.37) * 1.3
        let y = (position.y / 768 + 0.37) * 1.3
        
        // Store normalised coordinates in a new CGPoint
        let convertedPosition = CGPoint(x: x, y: y)
        
        // Return result to user
        return convertedPosition
    }
    
    
    // Function to control the pitch of oscillator based on x coordinate of touch
    func controlXParameter(posititon: CGPoint) {
        // Convert the current location of a touch
        let convertedPosition = convertCurrentLoaction(position: posititon)
        
        // Use new position to control frequency of oscillator
        oscFrequency = Double(convertedPosition.x) * 1200 + 80
    }
    
    
    // Function to control the reverb of oscillator based on y coordinate of touch
    func controlYParameter(position: CGPoint) {
        // Convert the current location of a given touch
        let convertedPosition = convertCurrentLoaction(position: position)
        
        // Use new position to control the volume of the oscillator
        oscAmplitude = Double(convertedPosition.y) * 0.6
    }
}
