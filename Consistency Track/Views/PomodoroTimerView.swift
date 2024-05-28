import SwiftUI
import ConfettiSwiftUI

struct PomodoroTimerView: View {
    @State private var timeRemaining = 1 // 1 segundo por defecto
    @State private var timerRunning = false
    @State private var workMode = true // true para modo trabajo, false para descanso
    @State private var showInfoPopup = false
    @State private var showSettingsPopup = false
    @State private var showTimerView = true
    @State private var completedPomodoros = 0
    @State private var consecutivePomodoros = 0
    @State private var confettiCounter = 0

    @State private var workTime = 10.0 // Work time in seconds
    @State private var breakTime = 10.0 // Break time in seconds
    @State private var newWorkTime = 1.0
    @State private var newBreakTime = 1.0
    @State private var timeUnit = "seconds" // Default time unit
    @State private var pomodoroGoal = 4
    @State private var newPomodoroGoal = 4.0
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Color de fondo según el modo y estado del temporizador
            Color(hue: 0.086, saturation: 0.141, brightness: 0.972)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Group {
                        if timerRunning {
                            (workMode ? Color(red: 0.72, green: 0.91, blue: 0.58) : Color(red: 0.97, green: 0.76, blue: 0.57))
                                .edgesIgnoringSafeArea(.all)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.5), value: timerRunning)
                        }
                    }
                )
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        showInfoPopup.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .sheet(isPresented: $showInfoPopup) {
                        PomodoroInfoView(showInfoPopup: $showInfoPopup)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        newWorkTime = timeUnit == "minutes" ? workTime / 60 : workTime
                        newBreakTime = timeUnit == "minutes" ? breakTime / 60 : breakTime
                        newPomodoroGoal = Double(pomodoroGoal)
                        showSettingsPopup.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .sheet(isPresented: $showSettingsPopup) {
                        PomodoroSettingsView(
                            showSettingsPopup: $showSettingsPopup,
                            workTime: $newWorkTime,
                            breakTime: $newBreakTime,
                            timeUnit: $timeUnit,
                            pomodoroGoal: $newPomodoroGoal,
                            applySettings: applySettings
                        )
                    }
                }
                
                Spacer()
                
                Text(workMode ? "Work Time" : "Break Time")
                    .font(.largeTitle)
                    .bold()
                    .transition(.opacity)
                
                Text(formatTime(timeRemaining))
                    .font(.system(size: 48, weight: .bold))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.gray.opacity(0.2)) // Fondo gris claro para el widget del temporizador
                    .cornerRadius(10)
                
                HStack(spacing: 20) {
                    Button(action: {
                        timerRunning.toggle()
                    }) {
                        Text(timerRunning ? "Pause" : "Start")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(timerRunning ? Color.red : Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        resetTimer()
                    }) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                Text("Pomodoros in streak 🔥: \(completedPomodoros)")
                    .font(.title2)
                    .bold()
                    .padding(.vertical)
                
                HStack(spacing: 10) {
                    ForEach(0..<pomodoroGoal, id: \.self) { index in
                        Rectangle()
                            .fill(index < (consecutivePomodoros % pomodoroGoal) ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 40, height: 20)
                            .cornerRadius(5)
                    }
                }
                
                ConfettiView(counter: $confettiCounter)
            }
            .onReceive(timer) { _ in
                if timerRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    timerRunning = false
                    if workMode {
                        completedPomodoros += 1
                        consecutivePomodoros += 1
                        if consecutivePomodoros % pomodoroGoal == 0 {
                            confettiCounter += 1
                        }
                    }
                    withAnimation(.easeInOut(duration: 1.5)) {
                        workMode.toggle()
                    }
                    timeRemaining = workMode ? Int(workTime) : Int(breakTime)
                }
            }
            .padding()
            .background(Color.clear) // Color transparente para evitar superposiciones
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func resetTimer() {
        timerRunning = false
        timeRemaining = workMode ? Int(workTime) : Int(breakTime)
    }

    private func applySettings() {
        workTime = timeUnit == "minutes" ? newWorkTime * 60 : newWorkTime
        breakTime = timeUnit == "minutes" ? newBreakTime * 60 : newBreakTime
        pomodoroGoal = Int(newPomodoroGoal)
        timeRemaining = workMode ? Int(workTime) : Int(breakTime)
    }
}

struct PomodoroSettingsView: View {
    @Binding var showSettingsPopup: Bool
    @Binding var workTime: Double
    @Binding var breakTime: Double
    @Binding var timeUnit: String
    @Binding var pomodoroGoal: Double
    var applySettings: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    showSettingsPopup.toggle()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding()
            }

            Text("Settings")
                .font(.largeTitle)
                .bold()
                .padding()

            VStack(spacing: 20) {
                Picker("Time Unit", selection: $timeUnit) {
                    Text("Seconds").tag("seconds")
                    Text("Minutes").tag("minutes")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("Adjust Work Time (\(timeUnit)): \(timeUnit == "minutes" ? String(format: "%.2f", workTime) : "\(Int(workTime))")")
                Slider(value: $workTime, in: 1...60, step: 1)
                    .padding()
                
                Text("Adjust Break Time (\(timeUnit)): \(timeUnit == "minutes" ? String(format: "%.2f", breakTime) : "\(Int(breakTime))")")
                Slider(value: $breakTime, in: 1...60, step: 1)
                    .padding()
                
                Text("Set Pomodoro Goal: \(Int(pomodoroGoal))")
                Slider(value: $pomodoroGoal, in: 1...7, step: 1)
                    .padding()

                Button(action: {
                    applySettings()
                    showSettingsPopup.toggle()
                }) {
                    Text("Apply")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct PomodoroInfoView: View {
    @Binding var showInfoPopup: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    showInfoPopup.toggle()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding()
            }

            Text("What is Pomodoro Technique?")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. It uses a timer to break work into intervals, typically 25 minutes in length, separated by short breaks. These intervals are known as 'pomodoros'.")
                .padding()

            Text("Why is it important?")
                .font(.title2)
                .bold()
                .padding(.top)

            Text("The Pomodoro Technique helps you stay focused and productive by creating a sense of urgency. It also encourages regular breaks, which can improve mental agility and reduce burnout.")
                .padding()
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}



#Preview {
    PomodoroTimerView()
}
