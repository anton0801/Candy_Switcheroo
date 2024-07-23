import SwiftUI
import SpriteKit

enum GameState {
    case pause, victory, gameOver, game
}

struct SwitcherooGameView: View {
    
    var level: Int
    
    @EnvironmentObject var gameManager: GameManager
    
    @State var switcherooScene: SwitcherooGameScene!
    
    @State var gameState: GameState = .game
    
    var body: some View {
        ZStack {
            if let witcherooScene = switcherooScene {
                SpriteView(scene: witcherooScene)
                    .ignoresSafeArea()
            }
            
            switch (gameState) {
            case .pause:
                PauseView()
            case .victory:
                VictoryGameView()
            case .gameOver:
                GameOverView()
            default:
                EmptyView()
            }
        }
        .onAppear {
            switcherooScene = SwitcherooGameScene(size: CGSize(width: 750, height: 1335), level: level)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restart_game"))) { _ in
            switcherooScene = switcherooScene.restartGame()
            withAnimation(.linear(duration: 0.5)) {
                self.gameState = .game
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_lose"))) { _ in
            switcherooScene.loseGame {
                self.gameManager.spendLife()
                withAnimation(.linear(duration: 0.5)) {
                    self.gameState = .gameOver
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_win"))) { _ in
            self.gameManager.spendLife()
            withAnimation(.linear(duration: 0.5)) {
                self.gameState = .victory
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_pause"))) { _ in
            withAnimation(.linear(duration: 0.5)) {
                self.gameState = .pause
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("continue_game"))) { _ in
            switcherooScene.continueGame {
            }
            withAnimation(.linear(duration: 0.5)) {
                self.gameState = .game
            }
        }
    }
    
}

#Preview {
    SwitcherooGameView(level: 1)
        .environmentObject(GameManager())
}
