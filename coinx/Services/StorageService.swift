import Foundation

class StorageService: ObservableObject {
    @Published var coins: [Coin] = []
    private let coinsKey = "saved_coins"
    
    init() {
        loadCoins()
    }
    
    private func loadCoins() {
        if let data = UserDefaults.standard.data(forKey: coinsKey) {
            if let decoded = try? JSONDecoder().decode([Coin].self, from: data) {
                self.coins = decoded
            }
        }
    }
    
    func saveCoin(_ coin: Coin) {
        coins.append(coin)
        saveToStorage()
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(coins) {
            UserDefaults.standard.set(encoded, forKey: coinsKey)
        }
    }
} 