//
// Project: AudioPlaybackVisualizer
//  File: UpgradedContentView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

// A richer SwiftUI UI for audio playback with animated background, meters, scrubbing, and volume.

import SwiftUI

struct UpgradedContentView: View {
    // Owns and observes the audio engine for playback state, timing, and metering updates
    @StateObject private var engine = AudioPlayerEngine()
    
    var body: some View {
        ZStack {
            // Dynamic gradient that animates only while audio is playing
            AnimatedBackground(isPlaying: engine.isPlaying)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 40)
                
                // 🔹 Play / Pause button + bars
                VStack(spacing: 40) {
                    // Tap to toggle playback — switches between play() and pause()
                    Button {
                        engine.isPlaying ? engine.pause() : engine.play()
                    } label: {
                        Image(systemName: engine.isPlaying ? "pause.circle.fill" : "play.circle.fill") // Swap icon based on isPlaying
                            .font(.system(size: 80))
                            .foregroundStyle(.white)
                            .shadow(color: .white.opacity(0.5), radius: 10)
                            .scaleEffect(engine.isPlaying ? 1.1 : 1.0) // Slightly enlarge while playing for feedback
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: engine.isPlaying) // Animate scale/icon changes
                    }
                    
                    // Stereo meters (left/right channels) driven by normalized decibel power
                    HStack(spacing: 20) {
                        DynamicBar(color1: .green, color2: .cyan,
                                   power: engine.leftPower, normalized: normalized(engine.leftPower)) // Left channel
                        DynamicBar(color1: .pink, color2: .indigo,
                                   power: engine.rightPower, normalized: normalized(engine.rightPower)) // Right channel
                    }
                    .frame(height: 200)
                }
                .padding(.top, 80)
                .padding(.bottom, 60)
                
                Spacer()
                
                // 🔹 Scrubber + time + volume
                VStack(spacing: 16) {
                    // Elapsed and total time labels
                    HStack {
                        Text(formatTime(engine.currentTime))
                        Spacer()
                        Text(formatTime(engine.duration))
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 40)
                    
                    // Scrubber — two-way bind via custom Binding to call seek() on drag
                    Slider(value: Binding(
                        get: { engine.currentTime },
                        set: { newValue in
                            engine.seek(to: newValue) // Jump playback position
                        }
                    ), in: 0...engine.duration)
                    .tint(.white)
                    
                    // Volume — map Double<->Float to talk to the engine
                    Slider(value: Binding(
                        get: { Double(engine.volume) },
                        set: { newValue in
                            engine.setVolume(Float(newValue)) // Apply new volume to player
                        }
                    ), in: 0...1)
                    .tint(.cyan)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
    
    // Convert AVAudioPlayer's decibel power (negative dB) to 0...1 for UI scaling
    // Values at or below minDb clamp to 0; 0 dB maps to 1
    func normalized(_ power: Float) -> CGFloat {
        let minDb: Float = -60
        let normalized = (power - minDb) / (0 - minDb)
        return CGFloat(max(0, min(normalized, 1)))
    }
    // Render seconds as m:ss (e.g., 1:05)
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct DynamicBar: View {
    let color1: Color
    let color2: Color
    let power: Float
    let normalized: CGFloat
    
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                // Main bar — height adjusts naturally with normalized magnitude
                GeometryReader { geo in // Read available height to scale bar proportionally
                    let height = geo.size.height * normalized // Map 0...1 to actual pixel height
                    VStack {
                        Spacer(minLength: 0)
                        LinearGradient(colors: [color1, color2], // Fancy vertical fill for the bar
                                       startPoint: .bottom,
                                       endPoint: .top)
                        .frame(height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .shadow(color: color2.opacity(0.7), radius: 8, y: -2)
                        .overlay( // Subtle glossy highlight
                            LinearGradient(colors: [.white.opacity(0.3), .clear],
                                           startPoint: .top, endPoint: .bottom)
                            .blendMode(.screen)
                        )
                        .animation(.interpolatingSpring(stiffness: 120, damping: 14), // Springy meter response
                                   value: normalized)
                    }
                }
                
                // Subtle reflection under the bar for depth
                Rectangle()
                    .fill(LinearGradient(colors: [color2.opacity(0.2), .clear],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(height: 10)
                    .blur(radius: 2)
            }
        }
        .frame(width: 40, height: 200)
    }
}

struct AnimatedBackground: View {
    var isPlaying: Bool
    @State private var animate = false
    
    var body: some View {
        // Background gradient that morphs colors while playing
        LinearGradient(gradient: Gradient(colors: [
            animate ? .orange : .purple,
            animate ? .pink : .blue
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .onChange(of: isPlaying) { playing in // Start/stop background animation with playback
            if playing {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { // Continuous pulse while playing
                    animate = true
                }
            } else {
                withAnimation(.easeOut(duration: 1)) { // Smoothly return to static colors when paused
                    animate = false
                }
            }
        }
    }
}


#Preview{
    UpgradedContentView()
}

