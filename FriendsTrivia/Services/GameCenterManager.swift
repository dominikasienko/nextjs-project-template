import GameKit
import SwiftUI

class GameCenterManager: NSObject, ObservableObject {
    static let shared = GameCenterManager()
    
    @Published var isAuthenticated = false
    @Published var isShowingAuthenticationModal = false
    
    private let leaderboardID = "com.friendstrivia.highscores"
    
    private let achievements = [
        "first_win": "com.friendstrivia.achievement.firstwin",
        "perfect_score": "com.friendstrivia.achievement.perfectscore",
        "multiplayer_master": "com.friendstrivia.achievement.multiplayermaster",
        "trivia_expert": "com.friendstrivia.achievement.triviaexpert"
    ]
    
    override init() {
        super.init()
        authenticatePlayer()
    }
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            if let viewController = viewController {
                self?.isShowingAuthenticationModal = true
                // The view controller needs to be presented by the game's view controller
            } else if localPlayer.isAuthenticated {
                self?.isAuthenticated = true
                self?.loadLeaderboards()
            } else {
                self?.isAuthenticated = false
                if let error = error {
                    print("GameCenter Authentication Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadLeaderboards() {
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { [weak self] leaderboards, error in
            if let error = error {
                print("Error loading leaderboards: \(error.localizedDescription)")
                return
            }
            // Leaderboards loaded successfully
        }
    }
    
    func submitScore(_ score: Int) {
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local,
            leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Error submitting score: \(error.localizedDescription)")
            }
        }
    }
    
    func showLeaderboard() {
        if let viewController = GKGameCenterViewController(state: .leaderboards) {
            viewController.gameCenterDelegate = self
            // Present the view controller
        }
    }
    
    // MARK: - Achievements
    
    func reportAchievement(_ achievementID: String, percentComplete: Double) {
        guard let achievementID = achievements[achievementID] else { return }
        
        let achievement = GKAchievement(identifier: achievementID)
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement]) { error in
            if let error = error {
                print("Error reporting achievement: \(error.localizedDescription)")
            }
        }
    }
    
    func unlockFirstWinAchievement() {
        reportAchievement("first_win", percentComplete: 100.0)
    }
    
    func unlockPerfectScoreAchievement() {
        reportAchievement("perfect_score", percentComplete: 100.0)
    }
    
    func updateMultiplayerMasterProgress(_ progress: Double) {
        reportAchievement("multiplayer_master", percentComplete: progress)
    }
    
    func updateTriviaExpertProgress(_ progress: Double) {
        reportAchievement("trivia_expert", percentComplete: progress)
    }
    
    func showAchievements() {
        if let viewController = GKGameCenterViewController(state: .achievements) {
            viewController.gameCenterDelegate = self
            // Present the view controller
        }
    }
    
    func resetAchievements() {
        GKAchievement.resetAchievements { error in
            if let error = error {
                print("Error resetting achievements: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - GKGameCenterControllerDelegate
extension GameCenterManager: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

// MARK: - SwiftUI View Extension
extension View {
    func withGameCenter() -> some View {
        self.onAppear {
            GameCenterManager.shared.authenticatePlayer()
        }
    }
}
