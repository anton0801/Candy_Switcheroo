import Foundation
import Combine

class GameManager: ObservableObject {
    static let shared = GameManager()
    
    private let maxLives = 3
    private let lifeRestoreInterval: TimeInterval = 20 * 60 // 20 минут в секундах
    private let lastLifeUpdateKey = "lastLifeUpdate"
    private let currentLivesKey = "currentLives"
    
    @Published var currentLives: Int {
        didSet {
            UserDefaults.standard.set(currentLives, forKey: currentLivesKey)
        }
    }
    
    private var lastLifeUpdate: Date {
        get {
            return UserDefaults.standard.object(forKey: lastLifeUpdateKey) as? Date ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastLifeUpdateKey)
        }
    }
    
    private var timer: AnyCancellable?

    init() {
        self.currentLives = UserDefaults.standard.integer(forKey: currentLivesKey)
        restoreLives()
        startLifeTimer()
    }
    
    func restoreLives() {
        let now = Date()
        let timeSinceLastUpdate = now.timeIntervalSince(lastLifeUpdate)
        
        // Рассчитываем, сколько жизней можно добавить
        if timeSinceLastUpdate >= lifeRestoreInterval {
            let livesToAdd = min(Int(timeSinceLastUpdate / lifeRestoreInterval), maxLives)
            currentLives = min(currentLives + livesToAdd, maxLives)
            lastLifeUpdate = now
        }
    }
    
    func spendLife() {
        guard currentLives > 0 else { return }
        currentLives -= 1
        lastLifeUpdate = Date()
        startLifeTimer()
    }
    
    func startLifeTimer() {
        timer = Timer.publish(every: lifeRestoreInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.restoreLives()
            }
    }
}
