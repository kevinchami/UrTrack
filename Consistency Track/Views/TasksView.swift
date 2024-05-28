import SwiftUI
import RealmSwift

struct TasksView: View {
    @ObservedResults(Task.self) var tasks
    @StateObject var realmManager = RealmManager()
    @State private var showOnlyUnfinishedTasks = false
    
    var filteredTasks: Results<Task> {
        if showOnlyUnfinishedTasks {
            return tasks.filter("completed == false")
        } else {
            return tasks
        }
    }
    
    var completedTasks: Int {
        tasks.filter { $0.completed }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hue: 0.086, saturation: 0.141, brightness: 0.972)
                    .edgesIgnoringSafeArea(.all) // Fondo deseado
                
                VStack {
                    Text("Tasks")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 18)
                    
                    Toggle("Show only unfinished tasks", isOn: $showOnlyUnfinishedTasks)
                        .padding(.horizontal)
                        .padding(.top, 0)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    if tasks.isEmpty {
                        Text("Add a task")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .padding(.top, 7)
                    } else {
                        Text("Swipe left to increment")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .padding(.top, 7)
                    }
                    
                    
                    
                    List {
                        ForEach(filteredTasks) { task in
                            TaskRow(task: task)
                                .listRowBackground(Color(hue: 0.086, saturation: 0.141, brightness: 0.972)) // Fondo deseado detrás de cada TaskRow
                                .swipeActions(edge: .leading) {
                                    Button(action: {
                                        incrementTask(task: task)
                                    }) {
                                        Label("Increment", systemImage: "plus")
                                    }
                                    .tint(.blue)
                                }
                        }
                        .onDelete(perform: $tasks.remove)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    
                    if !tasks.isEmpty {
                        ProgressCircleView(progress: Double(completedTasks), total: Double(tasks.count))
                            .padding(.top, 20)
                    }
                }
            }
        }
        .environmentObject(realmManager)
    }
    
    
    func incrementTask(task: Task) {
        realmManager.incrementCompletedDays(id: task.id)
    }
}

#Preview {
    TasksView()
}
