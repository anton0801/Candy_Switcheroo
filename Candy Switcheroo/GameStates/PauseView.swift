import SwiftUI

struct PauseView: View {
    
    @Environment(\.presentationMode) var pres
    
    var body: some View {
        VStack {
            pauseContent
        }
        .background(
            Image("pause_img")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var pauseContent: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack {
                Button {
                    continueAction()
                } label: {
                    Image("continue")
                }
                Spacer()
                Button {
                    restartAction()
                } label: {
                    Image("restart")
                }
            }
            .padding(.horizontal)
            
            Button {
                pres.wrappedValue.dismiss()
            } label: {
                VStack(spacing: 0) {
                    Image("menu_btn")
                    Text("Menu")
                        .font(.custom("ChunkyHazelnut", size: 52))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 24)
        }
    }
    
    private func continueAction() {
        NotificationCenter.default.post(name: Notification.Name("continue_game"), object: nil)
    }
    
    private func restartAction() {
        NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
    }
    
}

#Preview {
    PauseView()
}
