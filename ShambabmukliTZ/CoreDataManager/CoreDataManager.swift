import Foundation
import CoreData

enum CellState: Int16 {
    case alive = 0
    case dead = 1
    case life = 2
    case death = 3
}

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "ShambabmukliTZ")
    
    private let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }
    
    func fetchCells() async throws -> [MyNewEntity] {
        return try await context.perform {
            let fetchRequest: NSFetchRequest<MyNewEntity> = MyNewEntity.fetchRequest()
            return try self.context.fetch(fetchRequest)
        }
    }
    
    func saveCell(state: CellState) async throws {
        await context.perform {
            let newCell = MyNewEntity(context: self.context)
            newCell.cellState = state.rawValue
        }
        try await saveContext()
    }
    
    func clearAllData() async throws {
        try await context.perform {
            let entityNames = self.persistentContainer.managedObjectModel.entities.compactMap { $0.name }
            
            for entityName in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try self.context.execute(batchDeleteRequest)
                    print("Все данные из \(entityName) удалены")
                } catch {
                    print("Ошибка при удалении данных для сущности \(entityName): \(error)")
                    throw error
                }
            }
        }
        
        try await saveContext()
    }
}
