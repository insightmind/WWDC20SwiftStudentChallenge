// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation
import AVFoundation

/// The AudioManager is solely responsible for any audio in the game.
/// In our case the only audio is the background music.
class AudioManager {

    /// Singleton instance of the audio manager
    static let shared: AudioManager = .init()

    private let backgroundFilePath = Audio.backgroundMusic
    private var audioPlayer: AVAudioPlayer?

    /// Set this property to enable or disable the background music
    var isBackgroundMusicEnabled: Bool = true {
        didSet {
            if isBackgroundMusicEnabled {
                startBackgroundMusic()
            } else {
                stopBackgroundMusic()
            }
        }
    }

    private init() { /* This class should only be instantiated once */ }

    private func startBackgroundMusic() {
        guard !(audioPlayer?.isPlaying ?? false) else { return }
        guard let url = Bundle.main.url(forResource: backgroundFilePath, withExtension: FileTypes.mp3.rawValue) else { return }
        guard let avPlayer = try? AVAudioPlayer(contentsOf: url) else { return }

        audioPlayer = avPlayer

        // This will cause the music to repeat forever until stopped.
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()

        isBackgroundMusicEnabled = true
    }

    private func stopBackgroundMusic() {
        guard audioPlayer?.isPlaying ?? false else { return }
        audioPlayer?.stop()
        isBackgroundMusicEnabled = false
    }
}
