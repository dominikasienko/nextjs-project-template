import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        setupFirebase()
    }
    
    private func setupFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        setupPushNotifications()
        observeAuthChanges()
    }
    
    private func setupPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func signInAnonymously(completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // MARK: - Game Session Methods
    
    func createGameSession(mode: GameMode, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let gameSession = [
            "hostId": userId,
            "mode": mode.rawValue,
            "status": "waiting",
            "createdAt": FieldValue.serverTimestamp(),
            "players": [userId],
            "currentRound": 0
        ] as [String : Any]
        
        db.collection("gameSessions").addDocument(data: gameSession) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let sessionId = self.db.collection("gameSessions").document().documentID {
                    completion(.success(sessionId))
                }
            }
        }
    }
    
    func joinGameSession(sessionId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let sessionRef = db.collection("gameSessions").document(sessionId)
        sessionRef.updateData([
            "players": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Player Statistics
    
    func updatePlayerStats(score: Int, gameMode: GameMode) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let statsRef = db.collection("playerStats").document(userId)
        statsRef.setData([
            "lastPlayed": FieldValue.serverTimestamp(),
            "gamesPlayed": FieldValue.increment(1),
            "totalScore": FieldValue.increment(Int64(score))
        ], merge: true)
    }
    
    // MARK: - Leaderboard
    
    func fetchLeaderboard(completion: @escaping (Result<[(userId: String, score: Int)], Error>) -> Void) {
        db.collection("playerStats")
            .order(by: "totalScore", descending: true)
            .limit(to: 100)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let leaderboard = snapshot?.documents.compactMap { doc -> (String, Int)? in
                    guard let score = doc.data()["totalScore"] as? Int else { return nil }
                    return (doc.documentID, score)
                } ?? []
                
                completion(.success(leaderboard))
            }
    }
    
    // MARK: - In-App Purchases
    
    func unlockQuestionPack(packId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "unlockedPacks": FieldValue.arrayUnion([packId])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
