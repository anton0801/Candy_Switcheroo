import SwiftUI

struct ContentView: View {
    
    @StateObject var gameManager = GameManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("boy")
                    .offset(y: 150)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: 50)
                    
                    NavigationLink(destination: SettingsMap()
                        .navigationBarBackButtonHidden(true)) {
                            VStack(spacing: 0) {
                                Image("settings_btn")
                                Text("Settings")
                                    .font(.custom("ChunkyHazelnut", size: 62))
                                    .foregroundColor(.white)
                            }
                        }
                    
                    HStack {
                        ZStack {
                            Image("credits")
                            Text("0")
                                .font(.custom("ChunkyHazelnut", size: 52))
                                .foregroundColor(.white)
                                .offset(x: 40, y: -5)
                        }
                        
                        ZStack {
                            Image("lives")
                            Text("3")
                                .font(.custom("ChunkyHazelnut", size: 52))
                                .foregroundColor(.white)
                                .offset(x: 40, y: -5)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    NavigationLink(destination: LevelsMapView()
                        .environmentObject(gameManager)
                        .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                    }
                    
                    Spacer().frame(height: 50)
                    
                    NavigationLink(destination: RulesMap()
                        .navigationBarBackButtonHidden(true)) {
                        Image("rules_btn")
                    }
                }
            }
            .background(
                Image("image_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

#Preview {
    ContentView()
}
