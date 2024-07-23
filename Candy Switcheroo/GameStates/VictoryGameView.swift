import SwiftUI

struct VictoryGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        VStack {
            Spacer().frame(height: 80)
            Image("vic")
            ZStack {
                Image("credits")
                Text("+30")
                    .font(.custom("ChunkyHazelnut", size: 42))
                    .foregroundColor(.white)
                    .offset(x: 40, y: -5)
            }
            
            Spacer()
            
            Button {
                restartGame()
            } label: {
                Image("restart")
            }
            
            Spacer()
            
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                VStack(spacing: 0) {
                    Image("menu_btn")
                    Text("Menu")
                        .font(.custom("ChunkyHazelnut", size: 52))
                        .foregroundColor(.white)
                }
            }
        }
        .background(
            Image("victory_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private func restartGame() {
        NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
    }
    
}

#Preview {
    VictoryGameView()
}
