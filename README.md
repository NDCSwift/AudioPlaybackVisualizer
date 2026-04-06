# 🎵 Audio Playback Visualizer

A SwiftUI app that plays back an audio file and renders a real-time animated bar visualizer synced to the audio's frequency data using AVAudioEngine and AVAudioTap.

---

## 🤔 What this is

This project shows how to hook into AVAudioEngine to extract live audio samples during playback and drive a SwiftUI bar chart animation. It includes both a starter `ContentView` and an `UpgradedContentView` with more visual polish, backed by a dedicated `AudioPlayerEngine` that handles tap installation and FFT-style amplitude extraction.

## ✅ Why you'd use it

- **AudioPlayerEngine** — wraps `AVAudioEngine`, installs an audio tap, and publishes amplitude levels
- **BarShape** — custom `Shape` for drawing individual visualizer bars
- **UpgradedContentView** — enhanced UI with smoother animations and layout improvements
- **Bundled test audio** — `test_audio.mp3` included so you can run it immediately

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Tutorial-red?style=for-the-badge&logo=youtube)](https://youtu.be/X5ENYCLejGI)

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding97).

---

## 🚀 Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/NDCSwift/AudioPlaybackVisualizer.git
cd AudioPlaybackVisualizer
```

### 2. Open in Xcode
- Double-click `AudioPlaybackVisualizer.xcodeproj`

### 3. Set Your Development Team
In Xcode: **TARGET → Signing & Capabilities → Team**

### 4. Update the Bundle Identifier
Change `com.example.MyApp` to a unique identifier (e.g., `com.yourname.AudioVisualizer`).

---

## 🛠️ Notes

- The included `test_audio.mp3` is used for the demo — swap it with your own audio file as needed.
- If you see a code signing error, check that Team and Bundle ID are set.
- `UpgradedContentView` is the recommended starting point for customization.

## 📦 Requirements

- iOS 16+
- Xcode 15+
- Swift 5.9+

---

📺 [Watch the guide on YouTube](https://youtu.be/X5ENYCLejGI)
