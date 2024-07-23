import SwiftUI

struct SettingsMap: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var soundsInApp = false
    @State var musicInApp = false
    
    init() {
        let def = UserDefaults.standard
        soundsInApp = def.bool(forKey: "sounds")
        musicInApp = def.bool(forKey: "music")
    }
    
    var body: some View {
        VStack {
            Image("set")
            
            Spacer()
            
            ZStack {
                Image("set_bg")
                VStack(spacing: 0) {
                    Text("Sounds")
                        .font(.custom("ChunkyHazelnut", size: 52))
                        .foregroundColor(.white)
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            soundsInApp = !soundsInApp
                        }
                    } label: {
                        soundsIndicator
                    }
                    
                    Text("Music")
                        .font(.custom("ChunkyHazelnut", size: 52))
                        .foregroundColor(.white)
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            musicInApp = !musicInApp
                        }
                    } label: {
                        musicIndicator
                    }
                }
            }
            
            Button {
                saveAndLeave()
            } label: {
                Image("save_btn")
            }
            .offset(y: -30)
            
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
            Image("image_background")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var soundsIndicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.black)
                .frame(width: 250, height: 10)
            if soundsInApp {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.white)
                    .frame(width: 250, height: 10)
            }
        }
    }
    
    private var musicIndicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.black)
                .frame(width: 250, height: 10)
            if musicInApp {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.white)
                    .frame(width: 250, height: 10)
            }
        }
    }
    
    private func saveAndLeave() {
        UserDefaults.standard.set(soundsInApp, forKey: "sounds")
        UserDefaults.standard.set(musicInApp, forKey: "music")
        presMode.wrappedValue.dismiss()
    }
    
}

#Preview {
    SettingsMap()
}
