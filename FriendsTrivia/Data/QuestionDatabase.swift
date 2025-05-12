import Foundation

struct QuestionDatabase {
    static let questions: [Question] = [
        // Season 1 Pack
        Question(
            category: .facts,
            question: "How many seasons of Friends are there?",
            options: ["Eight", "Nine", "Ten", "Eleven"],
            correctAnswerIndex: 2,
            season: 1,
            difficulty: .easy,
            explanation: "Friends ran for exactly 10 seasons from 1994 to 2004."
        ),
        Question(
            category: .facts,
            question: "What year did Friends first premiere?",
            options: ["1992", "1993", "1994", "1995"],
            correctAnswerIndex: 2,
            season: 1,
            difficulty: .easy,
            explanation: "Friends premiered in 1994 on NBC."
        ),
        Question(
            category: .characters,
            question: "What is the name of Ross' pet monkey?",
            options: ["Marcel", "George", "Jack", "Bob"],
            correctAnswerIndex: 0,
            season: 1,
            difficulty: .easy,
            explanation: "Ross had a white-headed capuchin monkey named Marcel in season 1."
        ),
        // Characters Category
        Question(
            category: .characters,
            question: "What is Chandler Bing's middle name?",
            options: ["Muriel", "Francis", "Charles", "Matthew"],
            correctAnswerIndex: 0
        ),
        Question(
            category: .characters,
            question: "What are the names of Rachel's sisters?",
            options: ["Jill and Amy", "Amy and Julie", "Jill and Jessica", "Julie and Amy"],
            correctAnswerIndex: 0
        ),
        Question(
            category: .characters,
            question: "What is the name of Phoebe's alter ego?",
            options: ["Regina Phalange", "Princess Consuela", "Ursula Buffay", "Phoebe Princess"],
            correctAnswerIndex: 0
        ),
        
        // Relationships Category
        Question(
            category: .relationships,
            question: "How many times did Ross get divorced?",
            options: ["Two", "Three", "Four", "One"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .relationships,
            question: "Ross' first wife Carol leaves him for who?",
            options: ["Richard", "Susan Bunch", "Emily", "Elizabeth"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .relationships,
            question: "Who was married to a supposedly gay Canadian ice dancer named Duncan?",
            options: ["Rachel", "Monica", "Phoebe", "Carol"],
            correctAnswerIndex: 2
        ),
        
        // Episodes & Events Category
        Question(
            category: .episodes,
            question: "What ingredient did Rachel mistakingly put in her Thanksgiving trifle?",
            options: ["Chicken", "Beef", "Pork", "Turkey"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .episodes,
            question: "Who said, 'See, he's her lobster!'?",
            options: ["Monica", "Phoebe", "Rachel", "Joey"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .episodes,
            question: "Ross says whose name at the altar in London?",
            options: ["Emily", "Rachel", "Carol", "Monica"],
            correctAnswerIndex: 1
        ),
        
        // Locations & Places Category
        Question(
            category: .locations,
            question: "What store does Phoebe hate?",
            options: ["Pottery Barn", "Pier 1", "IKEA", "Crate & Barrel"],
            correctAnswerIndex: 0
        ),
        Question(
            category: .locations,
            question: "Where did Ross and Rachel have their first date?",
            options: ["Central Perk", "The planetarium", "Monica's apartment", "The museum"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .locations,
            question: "Chandler told Janice he was moving where to avoid seeing her again?",
            options: ["Canada", "Yemen", "Mexico", "England"],
            correctAnswerIndex: 1
        ),
        
        // Career & Work Category
        Question(
            category: .career,
            question: "Joey played Dr. Drake Ramoray on which soap opera show?",
            options: ["General Hospital", "Days of Our Lives", "The Young and the Restless", "All My Children"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .career,
            question: "What was Joey's nickname when he was working at Alessandro's?",
            options: ["Dragon", "Tiger", "Lion", "Bear"],
            correctAnswerIndex: 0
        ),
        Question(
            category: .career,
            question: "Monica worked as a waitress at what diner?",
            options: ["Moonlight Diner", "Moondance Diner", "Starlight Diner", "Sunshine Diner"],
            correctAnswerIndex: 1
        ),
        
        // Facts & Numbers Category
        Question(
            category: .facts,
            question: "How many pages was Rachel's letter to Ross?",
            options: ["16 pages", "18 pages (front and back)", "20 pages", "12 pages"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .facts,
            question: "How many categories does Monica have for her towels?",
            options: ["9", "10", "11", "12"],
            correctAnswerIndex: 2
        ),
        Question(
            category: .facts,
            question: "How many roses did Ross send Emily?",
            options: ["72", "84", "96", "108"],
            correctAnswerIndex: 0
        ),
        
        // Personal Details Category
        Question(
            category: .personal,
            question: "What is Rachel's favorite flower?",
            options: ["Roses", "Lilies", "Tulips", "Daisies"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .personal,
            question: "What fruit is Ross allergic to?",
            options: ["Strawberries", "Kiwi", "Pineapple", "Mango"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .personal,
            question: "What is Joey's pin number?",
            options: ["5639", "5369", "6539", "3659"],
            correctAnswerIndex: 0
        ),
        
        // Memorable Quotes Category
        Question(
            category: .quotes,
            question: "Which character famously said, 'PIVOT!'?",
            options: ["Ross", "Chandler", "Joey", "Monica"],
            correctAnswerIndex: 0
        ),
        Question(
            category: .quotes,
            question: "Joey doesn't share what?",
            options: ["Secrets", "Food", "Clothes", "Girls"],
            correctAnswerIndex: 1
        ),
        Question(
            category: .quotes,
            question: "What does Phoebe legally change her name to after her wedding?",
            options: ["Princess Banana Hammock", "Princess Consuela Bananahammock", "Princess Consuela Banana Hammock", "Princess Phoebe Banana"],
            correctAnswerIndex: 1
        ),
        
        // Additional questions from the provided list
        Question(
            category: .episodes,
            question: "Who had a pony and a boat at age 15?",
            options: ["Monica", "Rachel", "Phoebe", "Amy"],
            correctAnswerIndex: 1,
            season: 4,
            difficulty: .medium,
            explanation: "Rachel reveals she had both a pony and a boat when she was 15, highlighting her privileged upbringing."
        ),
        Question(
            category: .episodes,
            question: "What was Monica's nickname when she was a field hockey goalie?",
            options: ["Big Fat Goalie", "The Wall", "Mighty Mon", "The Blocker"],
            correctAnswerIndex: 0,
            season: 3,
            difficulty: .hard,
            explanation: "Monica was nicknamed 'Big Fat Goalie' during her field hockey days."
        ),
        Question(
            category: .facts,
            question: "What is actually Rachel's favorite movie?",
            options: ["Dangerous Liaisons", "Weekend at Bernie's", "Breakfast at Tiffany's", "Casablanca"],
            correctAnswerIndex: 1,
            season: 7,
            difficulty: .medium,
            explanation: "Despite trying to seem sophisticated, Rachel's actual favorite movie is Weekend at Bernie's."
        ),
        Question(
            category: .relationships,
            question: "Who dated a college student named Elizabeth Stevens?",
            options: ["Joey", "Chandler", "Ross", "Richard"],
            correctAnswerIndex: 2,
            season: 6,
            difficulty: .medium,
            explanation: "Ross dated his student Elizabeth Stevens, which caused complications at his job."
        ),
        Question(
            category: .personal,
            question: "What was the name of Ross and Monica's dog when they were kids?",
            options: ["Rover", "Chi-Chi", "Pogo", "Spot"],
            correctAnswerIndex: 1,
            season: 3,
            difficulty: .hard,
            explanation: "Ross and Monica had a dog named Chi-Chi when they were growing up."
        ),
        Question(
            category: .episodes,
            question: "What balloon got away during the Macy's Thanksgiving Day Parade in Season 1?",
            options: ["Underdog", "Snoopy", "Spider-Man", "Mickey Mouse"],
            correctAnswerIndex: 0,
            season: 1,
            difficulty: .hard,
            explanation: "The Underdog balloon got away during the parade, which was mentioned in the first Thanksgiving episode."
        ),
        Question(
            category: .career,
            question: "Ross worked as a professor at what school?",
            options: ["Columbia University", "New York University", "City College", "Hunter College"],
            correctAnswerIndex: 1,
            season: 5,
            difficulty: .medium,
            explanation: "Ross worked as a professor at New York University (NYU)."
        ),
        Question(
            category: .episodes,
            question: "Who gave birth to Chandler and Monica's twins?",
            options: ["Phoebe", "Erica", "Rachel", "Jill"],
            correctAnswerIndex: 1,
            season: 10,
            difficulty: .medium,
            explanation: "Erica was the birth mother of Monica and Chandler's twins, Jack and Erica."
        ),
        Question(
            category: .relationships,
            question: "Who gave Phoebe away at her wedding?",
            options: ["Joey", "Chandler", "Ross", "Her father"],
            correctAnswerIndex: 1,
            season: 10,
            difficulty: .medium,
            explanation: "Chandler walked Phoebe down the aisle at her wedding to Mike."
        ),
        
        // More questions from the provided list
        Question(
            category: .episodes,
            question: "What caused the fire at Rachel and Phoebe's apartment?",
            options: ["Candle", "Hair straightener", "Toaster", "Curling iron"],
            correctAnswerIndex: 1,
            season: 5,
            difficulty: .medium,
            explanation: "Rachel's hair straightener caused the fire in their apartment."
        ),
        Question(
            category: .relationships,
            question: "Phoebe is a surrogate for who?",
            options: ["Monica and Chandler", "Her brother Frank Jr. and Alice", "Ross and Rachel", "Joey's sister"],
            correctAnswerIndex: 1,
            season: 4,
            difficulty: .medium,
            explanation: "Phoebe acted as a surrogate mother for her half-brother Frank Jr. and his wife Alice."
        ),
        Question(
            category: .facts,
            question: "How many sisters does Joey have?",
            options: ["Five", "Six", "Seven", "Eight"],
            correctAnswerIndex: 2,
            season: 3,
            difficulty: .hard,
            explanation: "Joey has seven sisters."
        ),
        Question(
            category: .quotes,
            question: "Joey doesn't share what?",
            options: ["Secrets", "Food", "Girls", "Clothes"],
            correctAnswerIndex: 1,
            season: 5,
            difficulty: .easy,
            explanation: "JOEY DOESN'T SHARE FOOD! is one of Joey's most memorable quotes."
        ),
        Question(
            category: .episodes,
            question: "What do Monica and Chandler name their twins?",
            options: ["Jack and Judy", "Frank and Alice", "Erica and Jack", "Ross and Rachel"],
            correctAnswerIndex: 2,
            season: 10,
            difficulty: .medium,
            explanation: "They name their twins Erica (after their birth mother) and Jack (after Monica's father)."
        ),
        Question(
            category: .episodes,
            question: "Phoebe attempts to teach Joey what language?",
            options: ["Spanish", "Italian", "French", "German"],
            correctAnswerIndex: 2,
            season: 7,
            difficulty: .medium,
            explanation: "Phoebe tries to teach Joey French for an audition, with hilarious results."
        ),
        Question(
            category: .episodes,
            question: "Chick Jr. and Duck Jr. got stuck in what?",
            options: ["Cabinet", "Foosball table", "Oven", "Bathroom"],
            correctAnswerIndex: 1,
            season: 10,
            difficulty: .hard,
            explanation: "The birds got stuck inside Joey and Chandler's foosball table."
        ),
        Question(
            category: .facts,
            question: "Rachel was in which sorority?",
            options: ["Alpha Chi Omega", "Delta Delta Delta", "Kappa Kappa Delta", "Pi Beta Phi"],
            correctAnswerIndex: 2,
            season: 6,
            difficulty: .hard,
            explanation: "Rachel was a member of Kappa Kappa Delta during her college years."
        ),
        Question(
            category: .episodes,
            question: "Which character famously said, 'PIVOT!'?",
            options: ["Ross", "Chandler", "Joey", "Monica"],
            correctAnswerIndex: 0,
            season: 5,
            difficulty: .easy,
            explanation: "Ross repeatedly yells 'PIVOT!' while trying to move a couch up the stairs."
        )
    ]
    
    static func getQuestionsByCategory(_ category: Question.Category) -> [Question] {
        return questions.filter { $0.category == category }
    }
    
    static func getRandomQuestion() -> Question? {
        return questions.randomElement()
    }
    
    static func getRandomQuestionFromCategory(_ category: Question.Category) -> Question? {
        let categoryQuestions = getQuestionsByCategory(category)
        return categoryQuestions.randomElement()
    }
    
    // Get questions for a specific season (for in-app purchases)
    static func getQuestionsBySeason(_ season: Int) -> [Question] {
        return questions.filter { $0.season == season }
    }
    
    // Get questions by difficulty
    static func getQuestionsByDifficulty(_ difficulty: Question.Difficulty) -> [Question] {
        return questions.filter { $0.difficulty == difficulty }
    }
}

// Update Question.Category to include all necessary categories
extension Question {
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
    }
}
