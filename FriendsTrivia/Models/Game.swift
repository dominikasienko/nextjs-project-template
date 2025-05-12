import Foundation
import Combine

enum GameMode: String, Codable {
    case single = "Single Player"
    case multiplayer = "Multiplayer"
}

enum GameState: String {
    case notStarted
    case selectingCategory
    case playing
    case roundEnd
    case gameOver
}

class Game: ObservableObject {
    // MARK: - Published Properties
    @Published var currentQuestion: Question?
    @Published var score: Int = 0
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswerIndex: Int?
    @Published var gameMode: GameMode
    @Published var gameState: GameState = .notStarted
    @Published var timeRemaining: Int = 30
    @Published var currentStreak: Int = 0
    @Published var highestStreak: Int = 0
    @Published var selectedCategory: Question.Category?
    @Published var players: [Player] = []
    @Published var isHost: Bool = false
    @Published var groupCode: String?
    
    // MARK: - Private Properties
    private var questions: [Question] = []
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let questionsPerRound = 10
    private let timePerQuestion = 30
    private var statistics: GameStatistics
    
    // MARK: - Computed Properties
    var progress: Double {
        Double(currentQuestionIndex) / Double(questions.count)
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    var currentRoundNumber: Int {
        (currentQuestionIndex / questionsPerRound) + 1
    }
    
    // MARK: - Initialization
    init(mode: GameMode) {
        self.gameMode = mode
        self.statistics = GameStatistics()
        setupGame()
    }
    
    // MARK: - Game Setup
    private func setupGame() {
        if gameMode == .multiplayer {
            setupMultiplayerGame()
        } else {
            loadQuestions()
        }
        
        // Observe purchased question packs
        NotificationCenter.default.publisher(for: .questionPackPurchased)
            .sink { [weak self] _ in
                self?.loadQuestions()
            }
            .store(in: &cancellables)
    }
    
    private func setupMultiplayerGame() {
        if isHost {
            groupCode = String(Int.random(in: 100000...999999))
            FirebaseManager.shared.createGameSession(mode: gameMode) { [weak self] result in
                switch result {
                case .success(let sessionId):
                    self?.groupCode = sessionId
                case .failure(let error):
                    print("Error creating game session: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadQuestions() {
        // Get available questions based on purchases
        questions = StoreManager.shared.getAvailableQuestions()
        
        if let category = selectedCategory {
            questions = questions.filter { $0.category == category }
        }
        
        questions.shuffle()
        
        if !questions.isEmpty {
            currentQuestion = questions[0]
            startTimer()
        }
    }
    
    // MARK: - Game Logic
    func selectAnswer(_ index: Int) {
        guard selectedAnswerIndex == nil else { return }
        
        selectedAnswerIndex = index
        timer?.invalidate()
        
        let isCorrect = index == currentQuestion?.correctAnswerIndex
        
        if isCorrect {
            handleCorrectAnswer()
        } else {
            handleIncorrectAnswer()
        }
        
        // Update statistics
        statistics.recordAnswer(isCorrect: isCorrect, timeSpent: timePerQuestion - timeRemaining)
        
        // Update GameCenter achievements
        updateAchievements()
        
        if gameMode == .multiplayer {
            sendAnswerToOtherPlayers(index: index, isCorrect: isCorrect)
        }
    }
    
    private func handleCorrectAnswer() {
        let basePoints = currentQuestion?.points ?? 100
        let timeBonus = Int(Double(timeRemaining) * 3.33) // Up to 100 bonus points
        score += basePoints + timeBonus
        currentStreak += 1
        highestStreak = max(highestStreak, currentStreak)
    }
    
    private func handleIncorrectAnswer() {
        currentStreak = 0
    }
    
    func nextQuestion() {
        selectedAnswerIndex = nil
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            currentQuestion = questions[currentQuestionIndex]
            timeRemaining = timePerQuestion
            startTimer()
        } else {
            endGame()
        }
    }
    
    private func startTimer() {
        timeRemaining = timePerQuestion
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                if self.selectedAnswerIndex == nil {
                    self.selectAnswer(-1) // Time's up, count as wrong answer
                }
            }
        }
    }
    
    private func endGame() {
        gameState = .gameOver
        timer?.invalidate()
        
        // Submit score to GameCenter
        GameCenterManager.shared.submitScore(score)
        
        // Update player statistics
        if gameMode == .single {
            FirebaseManager.shared.updatePlayerStats(score: score, gameMode: gameMode)
        }
    }
    
    // MARK: - Multiplayer
    private func sendAnswerToOtherPlayers(index: Int, isCorrect: Bool) {
        guard let groupCode = groupCode else { return }
        
        FirebaseManager.shared.updateGameSession(
            sessionId: groupCode,
            data: [
                "lastAnswer": [
                    "playerId": FirebaseManager.shared.currentUser?.uid ?? "",
                    "answerIndex": index,
                    "isCorrect": isCorrect,
                    "score": score
                ]
            ]
        )
    }
    
    // MARK: - Achievements
    private func updateAchievements() {
        if currentStreak >= 10 {
            GameCenterManager.shared.unlockAchievement("perfect_streak")
        }
        
        if score >= 1000 {
            GameCenterManager.shared.unlockAchievement("high_scorer")
        }
        
        // Update progress for completing questions
        let progress = Double(statistics.totalQuestionsAnswered) / 100.0
        GameCenterManager.shared.updateProgress("question_master", progress: progress)
    }
}

// MARK: - Game Statistics
struct GameStatistics {
    var totalQuestionsAnswered: Int = 0
    var correctAnswers: Int = 0
    var averageTimePerQuestion: TimeInterval = 0
    private var totalTimeSpent: TimeInterval = 0
    
    mutating func recordAnswer(isCorrect: Bool, timeSpent: Int) {
        totalQuestionsAnswered += 1
        if isCorrect {
            correctAnswers += 1
        }
        totalTimeSpent += TimeInterval(timeSpent)
        averageTimePerQuestion = totalTimeSpent / TimeInterval(totalQuestionsAnswered)
    }
    
    var accuracy: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestionsAnswered)
    }
}

// MARK: - Player
struct Player: Identifiable, Codable {
    let id: String
    var name: String
    var score: Int
    var isReady: Bool
    var isHost: Bool
    
    init(id: String, name: String, score: Int = 0, isReady: Bool = false, isHost: Bool = false) {
        self.id = id
        self.name = name
        self.score = score
        self.isReady = isReady
        self.isHost = isHost
    }
}
