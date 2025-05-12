import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let category: Category
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let season: Int?  // Which season of Friends this question is from
    let episode: Int? // Optional episode number
    let difficulty: Difficulty
    let imageURL: String? // Optional image URL for visual questions
    let explanation: String? // Optional explanation for the answer
    
    enum Category: String, Codable, CaseIterable {
        case characters = "Characters"
        case relationships = "Relationships"
        case episodes = "Episodes & Events"
        case locations = "Locations & Places"
        case career = "Career & Work"
        case facts = "Facts & Numbers"
        case personal = "Personal Details"
        case quotes = "Memorable Quotes"
        
        var icon: String {
            switch self {
            case .characters: return "person.fill"
            case .relationships: return "heart.fill"
            case .episodes: return "tv.fill"
            case .locations: return "mappin.circle.fill"
            case .career: return "briefcase.fill"
            case .facts: return "number.circle.fill"
            case .personal: return "star.fill"
            case .quotes: return "quote.bubble.fill"
            }
        }
        
        var color: String {
            switch self {
            case .characters: return "#FF6B6B"
            case .relationships: return "#FF9F9F"
            case .episodes: return "#4ECDC4"
            case .locations: return "#45B7D1"
            case .career: return "#96CEB4"
            case .facts: return "#FFEEAD"
            case .personal: return "#D4A5A5"
            case .quotes: return "#9B59B6"
            }
        }
    }
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var points: Int {
            switch self {
            case .easy: return 100
            case .medium: return 200
            case .hard: return 300
            }
        }
        
        var icon: String {
            switch self {
            case .easy: return "1.circle.fill"
            case .medium: return "2.circle.fill"
            case .hard: return "3.circle.fill"
            }
        }
    }
    
    init(
        category: Category,
        question: String,
        options: [String],
        correctAnswerIndex: Int,
        season: Int? = nil,
        episode: Int? = nil,
        difficulty: Difficulty = .medium,
        imageURL: String? = nil,
        explanation: String? = nil
    ) {
        self.id = UUID()
        self.category = category
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.season = season
        self.episode = episode
        self.difficulty = difficulty
        self.imageURL = imageURL
        self.explanation = explanation
    }
    
    // Helper computed properties
    var correctAnswer: String {
        options[correctAnswerIndex]
    }
    
    var points: Int {
        difficulty.points
    }
    
    var seasonEpisodeText: String? {
        if let season = season {
            if let episode = episode {
                return "Season \(season), Episode \(episode)"
            }
            return "Season \(season)"
        }
        return nil
    }
}

// MARK: - Question Pack
struct QuestionPack: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let questions: [Question]
    let price: Decimal
    let isFree: Bool
    
    var formattedPrice: String {
        if isFree {
            return "Free"
        }
        return String(format: "$%.2f", NSDecimalNumber(decimal: price).doubleValue)
    }
}

// MARK: - Game Statistics
struct QuestionStatistics: Codable {
    let totalTimesAsked: Int
    let correctAnswers: Int
    let averageTimeToAnswer: TimeInterval
    
    var successRate: Double {
        guard totalTimesAsked > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalTimesAsked)
    }
}

// MARK: - Hashable & Equatable
extension Question: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.id == rhs.id
    }
}
