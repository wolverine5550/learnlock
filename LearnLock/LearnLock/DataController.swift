import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "LearnLock")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveActionPlan(book: String, goal: String, plan: String) {
        let newActionPlan = ActionPlan(context: container.viewContext)
        newActionPlan.book = book
        newActionPlan.goal = goal
        newActionPlan.plan = plan
        newActionPlan.createdAt = Date()
        
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving action plan: \(error.localizedDescription)")
        }
    }
    
    func fetchActionPlans() -> [ActionPlan] {
        let request: NSFetchRequest<ActionPlan> = ActionPlan.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ActionPlan.createdAt, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching action plans: \(error.localizedDescription)")
            return []
        }
    }
}
