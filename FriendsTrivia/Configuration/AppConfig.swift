import Foundation

enum AppConfig {
    // App Store Information
    static let appId = "YOUR_APP_ID"
    static let appName = "Friends Trivia"
    static let bundleId = "com.friendstrivia.app"
    static let version = "1.0.0"
    static let build = "1"
    
    // Feature Flags
    static let isMultiplayerEnabled = true
    static let isInAppPurchaseEnabled = true
    static let isGameCenterEnabled = true
    static let isPushNotificationEnabled = true
    
    // Firebase Configuration
    static let firebaseConfig = [
        "apiKey": "YOUR_FIREBASE_API_KEY",
        "authDomain": "YOUR_FIREBASE_AUTH_DOMAIN",
        "projectId": "YOUR_FIREBASE_PROJECT_ID",
        "storageBucket": "YOUR_FIREBASE_STORAGE_BUCKET",
        "messagingSenderId": "YOUR_FIREBASE_MESSAGING_SENDER_ID",
        "appId": "YOUR_FIREBASE_APP_ID",
        "measurementId": "YOUR_FIREBASE_MEASUREMENT_ID"
    ]
    
    // Game Configuration
    static let maxPlayersPerGame = 4
    static let questionsPerRound = 10
    static let timePerQuestion = 30 // seconds
    static let pointsPerCorrectAnswer = 100
    static let bonusPointsPerfectRound = 500
    
    // Store Configuration
    static let productIds = [
        "com.friendstrivia.seasonone",
        "com.friendstrivia.seasontwo",
        "com.friendstrivia.seasonthree",
        "com.friendstrivia.allseasons"
    ]
    
    // GameCenter Configuration
    static let leaderboardId = "com.friendstrivia.highscores"
    static let achievementIds = [
        "first_win": "com.friendstrivia.achievement.firstwin",
        "perfect_score": "com.friendstrivia.achievement.perfectscore",
        "multiplayer_master": "com.friendstrivia.achievement.multiplayermaster",
        "trivia_expert": "com.friendstrivia.achievement.triviaexpert"
    ]
}
