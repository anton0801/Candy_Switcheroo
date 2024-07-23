import SwiftUI

struct LevelsMapView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        ScrollViewReader { proxy2 in
                            ScrollView(.horizontal) {
                                ZStack(alignment: .bottom) {
                                    Image("map_levels")
                                        .resizable()
                                        .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                                        .aspectRatio(contentMode: .fill)
                                        .id("map_levels")
                                    
                                    VStack {
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("10")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: 90)
                                        .padding(.top, 42)
                                        .id(10)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("9")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -20)
                                        .padding(.top, 42)
                                        .id(9)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("8")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: 150)
                                        .padding(.top, 42)
                                        .id(8)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("7")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: 220)
                                        .padding(.top, 42)
                                        .id(7)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("6")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: 60)
                                        .padding(.top, 42)
                                        .id(6)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("5")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -220)
                                        .padding(.top, 42)
                                        .id(5)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("4")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -290)
                                        .padding(.top, 82)
                                        .id(4)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("3")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: -180)
                                        .padding(.top, 42)
                                        .id(3)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("2")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: 60)
                                        .padding(.top, 42)
                                        .id(2)
                                        NavigationLink(destination: EmptyView()) {
                                            ZStack {
                                                Image("level_unlocked")
                                                Text("1")
                                                    .font(.custom("ChunkyHazelnut", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .offset(x: 110)
                                        .padding([.top, .bottom], 42)
                                        .id(1)
                                    }
                                }
                            }
                            .id("horizontalScrollView")
                            .onAppear {
                                withAnimation {
                                    proxy2.scrollTo(1)
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo("horizontalScrollView", anchor: .bottom)
                        }
                    }
                }
                VStack {
                    Image("lev")
                        .resizable()
                        .frame(width: 150, height: 70)
                        .padding(.top)
                    Spacer()
                }
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    VStack {
                        Image("menu_btn")
                        Text("Menu")
                            .font(.custom("ChunkyHazelnut", size: 32))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LevelsMapView()
}
