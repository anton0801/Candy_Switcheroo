import SwiftUI

struct RulesMap: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        VStack {
            
            Spacer()
            
            ZStack {
                Image("cloud")
                Text("balls of different colors will fall from above. You need to figure out which vessel which ball should fall into the right vessel.")
                    .font(.custom("ChunkyHazelnut", size: 30))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
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
            Image("rules_image")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    RulesMap()
}
