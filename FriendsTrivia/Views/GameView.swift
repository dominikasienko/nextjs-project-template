import SwiftUI

struct GameView: View {
    @StateObject private var game: Game
    @State private var showingDiceRoll = true
    @State private var selectedCategory: Question.Category?
    @Environment(\.presentationMode) var presentationMode
    
    init(gameMode: GameMode) {
        _game = StateObject(wrappedValue: Game(mode: gameMode))
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            if showingDiceRoll {
                DiceRollView(isShowing: $showingDiceRoll, selectedCategory: $selectedCategory)
            } else {
                gameContent
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
        }
        .alert(isPresented: $game.isGameOver) {
            Alert(
                title: Text("Game Over!"),
                message: Text("Your final score: \(game.score)/\(game.questions.count)"),
                dismissButton: .default(Text("Back to Menu")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private var gameContent: some View {
        VStack(spacing: 20) {
            // Score and Progress
            HStack {
                Text("Score: \(game.score)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Question \(game.currentQuestionIndex + 1)/\(game.questions.count)")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            // Question Card
            if let currentQuestion = game.currentQuestion {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        // Answer Options
                        VStack(spacing: 12) {
                            ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                                AnswerButton(
                                    text: currentQuestion.options[index],
                                    isSelected: game.selectedAnswerIndex == index,
                                    isCorrect: index == currentQuestion.correctAnswerIndex,
                                    isRevealed: game.selectedAnswerIndex != nil,
                                    action: {
                                        if game.selectedAnswerIndex == nil {
                                            game.selectAnswer(index)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                }
                
                // Next Question Button
                if game.selectedAnswerIndex != nil {
                    Button(action: {
                        withAnimation {
                            game.nextQuestion()
                        }
                    }) {
                        Text("Next Question")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isRevealed: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if !isRevealed {
            return isSelected ? .blue : .white
        }
        if isCorrect {
            return .green
        }
        return isSelected ? .red : .white
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(isSelected || (isRevealed && isCorrect) ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(12)
                .shadow(radius: 3)
                .animation(.easeInOut, value: isSelected)
        }
        .disabled(isRevealed)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameView(gameMode: .single)
        }
    }
}
