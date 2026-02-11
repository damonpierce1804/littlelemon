import SwiftUI
import Combine


class CartManager: ObservableObject {
    
    @Published var items: [MenuItem: Int] = [:]
    
    var total: Double {
        items.reduce(0) { result, entry in
            let price = Double(entry.key.price.dropFirst()) ?? 0
            return result + (price * Double(entry.value))
        }
    }
    
    var itemCount: Int {
        items.values.reduce(0, +)
    }
    
    func add(item: MenuItem, quantity: Int) {
        items[item, default: 0] += quantity
    }
    
    func clearCart() {
        items.removeAll()
    }
}

