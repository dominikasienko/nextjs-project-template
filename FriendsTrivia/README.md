# Friends Trivia iOS App

A feature-rich trivia game based on the Friends TV show, designed with a modern card-based UI inspired by Friends: A to Z Guide and Trivia Deck.

## Features

- 🎮 Single and multiplayer game modes
- 🎲 Category selection with animated dice roll
- 🏆 Game Center integration for leaderboards and achievements
- 💰 In-app purchases for additional question packs
- 🔔 Push notifications for multiplayer invites
- 🌙 Dark mode support
- 📱 Universal app (iPhone & iPad)

## Requirements

- Xcode 14.0+
- iOS 15.0+
- CocoaPods
- Firebase account
- Apple Developer Account

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/FriendsTrivia.git
cd FriendsTrivia
```

2. Install dependencies
```bash
pod install
```

3. Open FriendsTrivia.xcworkspace in Xcode

4. Configure Firebase
- Create a new Firebase project
- Download GoogleService-Info.plist
- Add it to the project
- Update AppConfig.swift with your Firebase credentials

5. Configure App Store Connect
- Create a new app in App Store Connect
- Set up in-app purchases
- Configure Game Center achievements and leaderboards
- Update AppConfig.swift with your App Store credentials

## Configuration

### Firebase Setup
1. Enable Authentication, Firestore, and Cloud Messaging
2. Set up Security Rules for Firestore
3. Configure Push Notifications certificate

### Game Center Setup
1. Configure leaderboard
2. Set up achievements
3. Update GameCenterManager.swift with your IDs

### In-App Purchases
1. Create products in App Store Connect
2. Update StoreManager.swift with your product IDs

## Building for App Store

1. Update version and build numbers in:
- Info.plist
- AppConfig.swift
- AppStoreMetadata.json

2. Generate screenshots
```bash
fastlane snapshot
```

3. Prepare app for submission
```bash
fastlane release
```

## Architecture

- SwiftUI for UI
- MVVM architecture
- Firebase for backend
- StoreKit for in-app purchases
- GameKit for Game Center integration

## Project Structure

```
FriendsTrivia/
├── Models/
│   ├── Question.swift
│   └── Game.swift
├── Views/
│   ├── MainMenuView.swift
│   ├── GameView.swift
│   ├── DiceRollView.swift
│   └── LobbyView.swift
├── Services/
│   ├── FirebaseManager.swift
│   ├── StoreManager.swift
│   └── GameCenterManager.swift
├── Configuration/
│   ├── AppConfig.swift
│   ├── Entitlements.entitlements
│   └── AppStoreMetadata.json
└── Extensions/
    └── Color+Theme.swift
```

## Testing

Run the test suite:
```bash
fastlane test
```

## Deployment

1. Archive the app in Xcode
2. Upload to App Store Connect
3. Submit for review

## Support

For support, email support@friendstrivia.app or visit our website.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Design inspired by Friends: A to Z Guide and Trivia Deck
- Questions curated from official Friends sources
- Icons from SF Symbols

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
