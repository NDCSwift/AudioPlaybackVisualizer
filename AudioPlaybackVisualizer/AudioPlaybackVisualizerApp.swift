//
// Project: AudioPlaybackVisualizer
//  File: AudioPlaybackVisualizerApp.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

// App entry point — launches the main window with UpgradedContentView
import SwiftUI

// The @main annotated type bootstraps the SwiftUI app
@main
struct AudioPlaybackVisualizerApp: App {
    var body: some Scene {
        WindowGroup {
            UpgradedContentView() // Root view for the app
        }
    }
}
