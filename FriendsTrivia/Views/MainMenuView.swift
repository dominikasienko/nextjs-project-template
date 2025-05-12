import SwiftUI

struct MainMenuView: View {
    @State private var showingSinglePlayer = false
    @State private var showingMultiplayer = false
    @State private var showingStore = false
    @State private var showingLeaderboard = false
    @State private var showingSettings = false
    @State private var selectedCategory: Question.Category?
    
    // Animation states
    @State private var cardRotation: Double = 0
    @State private var cardScale: CGFloat = 1
    
    private let cardGradient = LinearGradient(
        colors: [Color.theme.primaryBlue, Color.theme.secondaryYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title Card
                    TitleCard()
                    
                    // Main Menu Options
                    ScrollView {
                        VStack(spacing: 20) {
                            // Play Solo Card
                            MenuCard(
                                title: "Play Solo",
                                subtitle: "Test your Friends knowledge",
                                icon: "person.fill",
                                gradient: cardGradient
                            ) {
                                withAnimation {
                                    showingSinglePlayer = true
                                }
                            }
                            
                            // Play with Friends Card
                            MenuCard(
                                title: "Play with Friends",
                                subtitle: "Compete in real-time",
                                icon: "person.3.fill",
                                gradient: cardGradient
                            ) {
                                withAnimation {
                                    showingMultiplayer = true
                                }
                            }
                            
                            // Question Packs Card
                            MenuCard(
                                title: "Question Packs",
                                subtitle: "Unlock more trivia",
                                icon: "gift.fill",
                                gradient: cardGradient
                            ) {
                                withAnimation {
                                    showingStore = true
                                }
                            }
                            
                            // Leaderboard Card
                            MenuCard(
                                title: "Leaderboard",
                                subtitle: "See top players",
                                icon: "trophy.fill",
                                gradient: cardGradient
                            ) {
                                withAnimation {
                                    showingLeaderboard = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingStore) {
                StoreView()
            }
            .fullScreenCover(isPresented: $showingSinglePlayer) {
                GameView(gameMode: .single)
            }
            .fullScreenCover(isPresented: $showingMultiplayer) {
                LobbyView()
            }
            .sheet(isPresented: $showingLeaderboard) {
                LeaderboardView()
            }
        }
    }
}

// MARK: - Title Card View
struct TitleCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Friends")
                .font(.custom("Helvetica Neue Bold", size: 48))
                .foregroundColor(.white)
            
            Text("TRIVIA")
                .font(.custom("Helvetica Neue", size: 32))
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.theme.primaryBlue, Color.theme.primaryBlue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 10)
        )
        .padding(.horizontal)
        .rotation3DEffect(
            .degrees(isAnimating ? 360 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Menu Card View
struct MenuCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color.white.opacity(0.2)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .opacity(0.9)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(gradient)
            )
            .shadow(radius: 5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
