import SwiftUI

struct DiceRollView: View {
    @Binding var isShowing: Bool
    @Binding var selectedCategory: Question.Category?
    
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var showResult = false
    
    private let categories = Question.Category.allCases
    
    var body: some View {
        VStack {
            if !showResult {
                // Dice Rolling Animation
                Image(systemName: "dice.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        animateDice()
                    }
            } else {
                // Category Result
                VStack(spacing: 20) {
                    Text("Category Selected:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(selectedCategory?.rawValue ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Button(action: {
                        withAnimation {
                            isShowing = false
                        }
                    }) {
                        Text("Start Game")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal)
                }
                .transition(.opacity)
            }
        }
        .padding()
    }
    
    private func animateDice() {
        // Initial animation values
        rotation = 0
        scale = 1
        opacity = 1
        showResult = false
        
        // Dice rolling animation
        withAnimation(.easeInOut(duration: 2)) {
            rotation = 1080 // Multiple 360-degree rotations
            scale = 1.2
        }
        
        // After rolling animation, show the result
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            selectedCategory = categories.randomElement()
            withAnimation(.easeInOut) {
                showResult = true
            }
        }
    }
}

struct DiceRollView_Previews: PreviewProvider {
    static var previews: some View {
        DiceRollView(
            isShowing: .constant(true),
            selectedCategory: .constant(.characters)
        )
    }
}
