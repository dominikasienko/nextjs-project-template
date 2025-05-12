import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    let name: String
    var isReady: Bool = false
}

struct LobbyView: View {
    @State private var groupCode = ""
    @State private var playerName = ""
    @State private var isHost = false
    @State private var players: [Player] = []
    @State private var showingGameView = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Generate a random 6-digit code for the group
    private let generatedGroupCode = String(Int.random(in: 100000...999999))
    
    var body: some View {
        VStack(spacing: 25) {
            // Header
            Text("Game Lobby")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Join or Create Game Section
            VStack(spacing: 20) {
                if !isHost && groupCode.isEmpty {
                    // Player Name Input
                    TextField("Enter your name", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Join or Create Options
                    HStack(spacing: 20) {
                        Button("Join Game") {
                            showJoinGameAlert()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Button("Create Game") {
                            createGame()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                } else {
                    // Show Group Code
                    VStack(spacing: 10) {
                        Text("Group Code:")
                            .font(.title2)
                        Text(isHost ? generatedGroupCode : groupCode)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Players List
            VStack(alignment: .leading, spacing: 10) {
                Text("Players")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(players) { player in
                            PlayerRow(player: player)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Start Game Button (Only visible for host)
            if isHost {
                Button(action: {
                    startGame()
                }) {
                    Text("Start Game")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(players.count >= 2 ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(players.count < 2)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Join Game"),
                message: Text("Enter the group code:"),
                primaryButton: .default(Text("Join")) {
                    joinGame()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationDestination(isPresented: $showingGameView) {
            GameView(gameMode: .multiplayer)
        }
    }
    
    private func showJoinGameAlert() {
        if playerName.isEmpty {
            alertMessage = "Please enter your name first"
            showingAlert = true
            return
        }
        showingAlert = true
    }
    
    private func createGame() {
        if playerName.isEmpty {
            alertMessage = "Please enter your name first"
            showingAlert = true
            return
        }
        
        isHost = true
        groupCode = generatedGroupCode
        players.append(Player(name: playerName + " (Host)", isReady: true))
    }
    
    private func joinGame() {
        // In a real app, this would validate the group code with a server
        players.append(Player(name: playerName))
    }
    
    private func startGame() {
        showingGameView = true
    }
}

struct PlayerRow: View {
    let player: Player
    
    var body: some View {
        HStack {
            Text(player.name)
                .font(.body)
            
            Spacer()
            
            Image(systemName: player.isReady ? "checkmark.circle.fill" : "circle")
                .foregroundColor(player.isReady ? .green : .gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LobbyView()
        }
    }
}
