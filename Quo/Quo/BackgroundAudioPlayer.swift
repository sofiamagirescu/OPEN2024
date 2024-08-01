//
//  BackgroundAudioPlayer.swift
//  Quo
//
//  Created by Calin Gavriliu on 01.08.2024.
//

import SwiftUI
import AVKit

class AudioPlayer: ObservableObject {
    private var players: [AVAudioPlayer?] = []
    private var fadeTimer: Timer?
    private(set) var currentTrackIndex: Int = 0
    
    func loadTracks(fileNames: [String]) {
        players = fileNames.map { fileName in
            if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    player.numberOfLoops = -1
                    return player
                } catch {
                    print("Error loading audio file \(fileName): \(error)")
                    return nil
                }
            }
            return nil
        }
    }
    
    func playAllTracks() {
        guard !players.isEmpty else { return }
        
        fadeTimer?.invalidate()
        
        for player in players {
            player?.currentTime = 0
            player?.volume = 0.0
            player?.play()
        }
        
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let currentTrack = self.players[self.currentTrackIndex] {
                if currentTrack.volume < 1.0 {
                    currentTrack.volume += 0.05
                } else {
                    self.fadeTimer?.invalidate()
                }
            }
        }
    }
    
    func switchToTrack(at index: Int) {
        guard index >= 0 && index < players.count else { return }
        
        fadeTimer?.invalidate()
        
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let currentTrack = self.players[self.currentTrackIndex], let nextTrack = self.players[index] {
                if currentTrack.volume > 0.0 {
                    currentTrack.volume -= 0.05
                    nextTrack.volume += 0.05
                } else {
                    self.fadeTimer?.invalidate()
                    self.currentTrackIndex = index
                }
            }
        }
    }
    
    func stopAllTracks() {
        fadeTimer?.invalidate()

        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            var allTracksFadedOut = true
            for player in self.players {
                if let player = player, player.volume > 0.0 {
                    player.volume -= 0.05
                    allTracksFadedOut = false
                }
            }
            if allTracksFadedOut {
                self.fadeTimer?.invalidate()
                for player in self.players {
                    player?.stop()
                    player?.currentTime = 0
                }
            }
        }
    }
}
