import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var tasks: [Task] = []
    
    init() {
        openRealm()
        getTasks()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 7,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 7 {
                        // Migración necesaria
                    }
                }
            )
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addTask(taskTitle: String, goalDays: Int, category: String) {
        performOnMainThread {
            if let localRealm = self.localRealm {
                do {
                    try localRealm.write {
                        let newTask = Task(value: ["title": taskTitle, "goalDays": goalDays, "completedDays": 0, "completed": false, "category": category])
                        localRealm.add(newTask)
                        self.getTasks()
                        print("Added new task to Realm: \(newTask)")
                    }
                } catch {
                    print("Error adding task to Realm: \(error)")
                }
            }
        }
    }
    
    func getTasks() {
        performOnMainThread {
            if let localRealm = self.localRealm {
                let allTasks = localRealm.objects(Task.self).sorted(byKeyPath: "completed")
                self.tasks = Array(allTasks)
            }
        }
    }
    
    func updateTask(id: ObjectId, title: String, goalDays: Int, category: String) {
        performOnMainThread {
            if let localRealm = self.localRealm {
                do {
                    if let taskToUpdate = localRealm.object(ofType: Task.self, forPrimaryKey: id) {
                        try localRealm.write {
                            // Verificar si el nuevo número de días objetivo es menor que los días completados
                            if goalDays < taskToUpdate.completedDays {
                                print("Error: New goal days cannot be less than completed days")
                                return
                            }
                            // Actualizar el título y los días objetivo
                            taskToUpdate.title = title
                            taskToUpdate.goalDays = goalDays
                            taskToUpdate.category = category
                            
                            // Si se incrementa el número de días objetivo, marcar la tarea como no completada
                            if goalDays > taskToUpdate.completedDays {
                                taskToUpdate.completed = false
                            }
                            self.getTasks()
                            print("Updated task \(id) with new title: \(title), goal days: \(goalDays), and category: \(category)")
                        }
                    }
                } catch {
                    print("Error updating task in Realm: \(error)")
                }
            }
        }
    }
    
    func incrementCompletedDays(id: ObjectId) {
        performOnMainThread {
            if let localRealm = self.localRealm {
                do {
                    if let taskToUpdate = localRealm.object(ofType: Task.self, forPrimaryKey: id) {
                        try localRealm.write {
                            if taskToUpdate.completedDays < taskToUpdate.goalDays {
                                taskToUpdate.completedDays += 1
                                if taskToUpdate.completedDays >= taskToUpdate.goalDays {
                                    taskToUpdate.completed = true
                                }
                                self.getTasks()
                                print("Incremented completed days for task \(id) to \(taskToUpdate.completedDays)")
                            } else {
                                print("Task \(id) has already reached the goal of \(taskToUpdate.goalDays) days.")
                            }
                        }
                    }
                } catch {
                    print("Error incrementing completed days for task in Realm: \(error)")
                }
            }
        }
    }
    
    func deleteTask(id: ObjectId) {
        performOnMainThread {
            if let localRealm = self.localRealm {
                do {
                    if let taskToDelete = localRealm.object(ofType: Task.self, forPrimaryKey: id) {
                        try localRealm.write {
                            localRealm.delete(taskToDelete)
                            self.getTasks()
                            print("Deleted task with id: \(id)")
                        }
                    }
                } catch {
                    print("Error deleting task from Realm: \(error)")
                }
            }
        }
    }
    
    private func performOnMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
