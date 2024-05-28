import SwiftUI

struct ContentView: View {
    @StateObject var realmManager = RealmManager()
    @State private var showWelcomeScreen = true
    @State private var showPomodoroTimer = false
    @State private var showAddTaskView = false
    @State private var showTutorial = true  // Track if the tutorial should be shown
    
    var body: some View {
        Group {
            if showWelcomeScreen {
                WelcomeView(isWelcomeScreenShown: $showWelcomeScreen)
                    .transition(.opacity)
            } else {
                ZStack(alignment: .bottomTrailing) {
                    TasksView()
                        .environmentObject(realmManager)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                showPomodoroTimer.toggle()
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 50)
                                        .foregroundColor(Color.orange)
                                    Image(systemName: "timer")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .overlay(
                                // Tutorial overlay
                                showTutorial ?
                                    Text("Pomodoro Timer")
                                    .font(.footnote)
                                        .padding(8)
                                        .background(Color.black.opacity(0.75))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .offset(y: -70)
                                        .transition(.scale)
                                : nil
                            )
                            Spacer()
                        }
                    }
                    
                    SmallAddButton()
                        .padding()
                        .onTapGesture {
                            showAddTaskView.toggle()
                        }
                    
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView()
                        .environmentObject(realmManager)
                }
                .sheet(isPresented: $showPomodoroTimer) {
                    PomodoroTimerView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
                .onAppear {
                    // Check if it's the first time the user opens the app
                    if UserDefaults.standard.bool(forKey: "hasSeenTutorial") == false {
                        showTutorial = true
                        UserDefaults.standard.set(true, forKey: "hasSeenTutorial")
                    }
                    // Automatically hide tutorial after 8 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                        withAnimation {
                            showTutorial = false
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: showWelcomeScreen)
    }
}

#Preview {
    ContentView()
}
