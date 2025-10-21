// Audio playback engine that wraps AVAudioPlayer and publishes state for SwiftUI

//
// Project: AudioPlaybackVisualizer
//  File: AudioPlayerEngine.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger


import AVFoundation
import SwiftUI
import Combine

// ObservableObject so SwiftUI views can react to published changes (playback, meters, time)
final class AudioPlayerEngine: ObservableObject {
    @Published var isPlaying = false // Drives UI state and background animation
    @Published var currentTime: TimeInterval = 0.0 // Seconds into the track
    @Published var leftPower: Float = -160 // Peak power (dB) for left channel
    @Published var rightPower: Float = -160 // Peak power (dB) for right channel
    
    // Underlying system audio player (kept private to control access)
    private var audioPlayer: AVAudioPlayer?
    // Polling timer to update meters and current time while playing
    private var timer: Timer?
    
    // Expose duration safely; default to 1 to avoid division by zero in sliders
    var duration: TimeInterval { audioPlayer?.duration ?? 1 }
    
    // Proxy volume to avoid leaking the audioPlayer reference
    var volume: Float {
        get { audioPlayer?.volume ?? 0.5 }
        set { audioPlayer?.volume = newValue }
    }
    
    init() {
        guard let url = Bundle.main.url(forResource: "test_audio", withExtension: "mp3") else { return } // Load bundled demo audio
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url) // Create player from file URL
            audioPlayer?.prepareToPlay() // Preload buffers for quicker start
            audioPlayer?.isMeteringEnabled = true // Enable power level metering
        } catch {
            print("Error initializing player: \(error)")
        }
    }
    
    // Start playback and begin periodic UI updates
    func play() {
        audioPlayer?.play()
        isPlaying = true
        startTimer() // Start polling meters/time
    }
    
    // Pause playback and stop UI updates
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer() // Stop polling
    }
    
    // Drive metering at ~20 Hz for smooth animations
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in // 50ms cadence
            self.updateVisualizer()
        }
    }
    
    // Tear down the timer safely
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Refresh current time and channel power from the player
    private func updateVisualizer() {
        audioPlayer?.updateMeters() // Recompute power levels
        currentTime = audioPlayer?.currentTime ?? 0.0 // Publish elapsed time
        leftPower = audioPlayer?.peakPower(forChannel: 0) ?? -160 // Left channel dB
        rightPower = audioPlayer?.peakPower(forChannel: 1) ?? -160 // Right channel dB
    }
    
    // Jump to a specific playback time (seconds)
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    // Update output volume (0.0 - 1.0)
    func setVolume(_ value: Float) {
        audioPlayer?.volume = value
    }
}

