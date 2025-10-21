//
// Project: AudioPlaybackVisualizer
//  File: BarShape.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

// Custom Shape that draws a vertical bar scaled to a 0...1 magnitude

import SwiftUI

// Shape lets us describe a path procedurally; SwiftUI re-renders as magnitude changes
struct BarShape: Shape {
    let magnitude: CGFloat
    
    // Compute a rectangle whose height is a percentage of the available rect
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height = rect.height * magnitude // Scale to available height
        let y = rect.height - height // Anchor bar to the bottom
        path.addRect(CGRect(x: 0, y: y, width: rect.width, height: height)) // Draw the bar
        return path
    }
}
