import SwiftUI
import RealmSwift
import ConfettiSwiftUI

struct TaskRow: View {
    @ObservedRealmObject var task: Task
    @State private var showEditTaskView = false
    @State private var confettiCounter = 0
    
    var categoryIcon: String {
        switch task.category {
        case "Sport":
            return "figure.run"
        case "Studies":
            return "book.fill"
        case "Work":
            return "briefcase.fill"
        case "Hobbies":
            return "star.fill"
        case "Habits":
            return "repeat"
        case "Music":
            return "music.note"
        default:
            return "square.and.pencil"
        }
    }
    
    var body: some View {
        ZStack {
            if task.completed {
                ConfettiView(counter: $confettiCounter)
            }
            
            HStack(spacing: 20) {
                Image(systemName: categoryIcon)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(task.title)
                    ProgressView(value: task.progress)
                        .progressViewStyle(LinearProgressViewStyle())
                    Text("\(task.completedDays) / \(task.goalDays) days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: task.completed ? "checkmark.circle" : "circle")
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(task.completed ? Color(red: 0.18, green: 0.80, blue: 0.44) : Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .onTapGesture {
                showEditTaskView.toggle()
            }
            .sheet(isPresented: $showEditTaskView) {
                EditTaskView(task: task)
                    .environmentObject(RealmManager())
            }
        }
        .onChange(of: task.completed) { completed in
            if completed {
                confettiCounter += 1
            }
        }
    }
}

#Preview {
    TaskRow(task: Task())
}
