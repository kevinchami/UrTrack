import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var goalDays: String = ""
    @State private var category: String = "Other"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color(hue: 0.086, saturation: 0.141, brightness: 0.972)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Task")
                    .font(.largeTitle).bold()
                    .foregroundColor(.black)
                    .padding(.bottom, 20)

                TextField("Task Title: Home Squats", text: $title)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)

                TextField("Goal Days", text: $goalDays)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                    .padding(.bottom, 20)
                
                HStack {
                    Text("Category")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Picker("Category", selection: $category) {
                        Text("Sport").tag("Sport")
                        Text("Studies").tag("Studies")
                        Text("Work").tag("Work")
                        Text("Hobbies").tag("Hobbies")
                        Text("Habits").tag("Habits")
                        Text("Music").tag("Music")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                Button {
                    if title.isEmpty || goalDays.isEmpty {
                        alertMessage = "Both task title and goal days are required."
                        showAlert = true
                    } else if let goalDaysInt = Int(goalDays) {
                        realmManager.addTask(taskTitle: title, goalDays: goalDaysInt, category: category)
                        dismiss()
                    } else {
                        alertMessage = "Goal days must be a number."
                        showAlert = true
                    }
                } label: {
                    Text("Add Task")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Input Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal)
        }
    }
}

#Preview {
    AddTaskView()
        .environmentObject(RealmManager())
}
