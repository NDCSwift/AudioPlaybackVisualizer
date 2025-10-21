//
// Project: AudioPlaybackVisualizer
//  File: ContentView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

// Minimal version of the UI showing play/pause and simple bar meters
import SwiftUI

struct ContentView: View {
    // Share the audio engine with the view so UI reacts to its published properties
    @StateObject private var engine = AudioPlayerEngine()
    
    var body: some View {
        ZStack {
            // Simple static background gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                // Toggle between play and pause
                Button {
                    engine.isPlaying ? engine.pause() : engine.play()
                } label: {
                    Image(systemName: engine.isPlaying ? "pause.circle.fill" : "play.circle.fill") // Reflect current play state
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                }
                
                // Two simple bars whose heights scale with normalized power
                HStack(spacing: 16) {
                    BarShape(magnitude: normalized(engine.leftPower))
                        .frame(width: 40, height: 100)
                        .foregroundStyle(.blue)
                    
                    BarShape(magnitude: normalized(engine.rightPower))
                        .frame(width: 40, height: 100)
                        .foregroundStyle(.purple)
                }
                .animation(.easeOut(duration: 0.05), value: engine.leftPower) // Smooth meter updates
            }
            .padding()
            
        }
    }
    
    // Map decibel values (negative) to 0...1 for drawing
    func normalized(_ power: Float) -> CGFloat {
        let minDb: Float = -60
        let normalized = (power - minDb) / (0 - minDb)
        return CGFloat(max(0, min(normalized, 1)))
    }
}

#Preview {
    ContentView()
}
