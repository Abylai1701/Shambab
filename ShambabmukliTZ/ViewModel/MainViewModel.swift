import Foundation
import Combine

class MainViewModel {
    
    var coreDataManager = CoreDataManager.shared
    @Published var cells: [MyNewEntity] = []
    
    func addNewCell(state: Bool) {
        Task {
            if state {
                try await CoreDataManager.shared.saveCell(state: .alive)
            } else {
                try await CoreDataManager.shared.saveCell(state: .dead)
            }
            self.cells = try await CoreDataManager.shared.fetchCells()
            await checkCells()
        }
    }
    
    func fetchCells() {
        Task {
            self.cells = try await CoreDataManager.shared.fetchCells()
        }
    }
    
    func checkCells() async {
        guard cells.count >= 3 else { return }
        
        let lastThreeCells = cells.suffix(3)
        let cellStates = lastThreeCells.map { $0.cellState }
        
        do {
            if cellStates.allSatisfy({ $0 == CellState.alive.rawValue }) {
                print("Три живые клетки подряд!")
                try await CoreDataManager.shared.saveCell(state: .life)
                self.cells = try await CoreDataManager.shared.fetchCells()
            } else if cellStates.allSatisfy({ $0 == CellState.dead.rawValue }) {
                print("Три мёртвые клетки подряд!")
                try await CoreDataManager.shared.saveCell(state: .death)
                self.cells = try await CoreDataManager.shared.fetchCells()
            }
        } catch {
            print("Ошибка при проверке клеток: \(error)")
        }
    }
}
