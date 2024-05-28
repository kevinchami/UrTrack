import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var goalDays: Int = 0 // Número de días objetivo
    @Persisted var completedDays: Int = 0 // Número de días completados
    @Persisted var completed = false // Este atributo puede indicar si la tarea está completamente cumplida
    @Persisted var category: String = "Other"

    
    var progress: Double {
        return goalDays > 0 ? Double(completedDays) / Double(goalDays) : 0
    }
}
