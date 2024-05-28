import SwiftUI
import RealmSwift

struct EditTaskView: View {
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var goalDays: String
    @State private var category: String
    var task: Task

    init(task: Task) {
        _title = State(initialValue: task.title)
        _goalDays = State(initialValue: String(task.goalDays))
        _category = State(initialValue: task.category)
        self.task = task
    }

    var body: some View {
        ZStack {
            Color(hue: 0.086, saturation: 0.141, brightness: 0.972)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Edit Task")
                    .font(.largeTitle).bold()
                    .foregroundColor(.black)
                    .padding(.bottom, 20)

                TextField("Task Title", text: $title)
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
                    if let goalDaysInt = Int(goalDays), !title.isEmpty {
                        realmManager.updateTask(id: task.id, title: title, goalDays: goalDaysInt, category: category)
                        dismiss()
                    }
                } label: {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)

                Button(role: .destructive) {
                    realmManager.deleteTask(id: task.id)
                    dismiss()
                } label: {
                    Text("Delete Task")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 40)
                        .background(Color.red)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal)
        }
    }
}

#Preview {
    EditTaskView(task: Task())
        .environmentObject(RealmManager())
}
