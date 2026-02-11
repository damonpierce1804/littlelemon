//
//  Little_LemonApp.swift
//  Little Lemon
//
//  Created by Jesus Cervantes on 2/4/26.
//

import SwiftUI

@main
struct Little_LemonApp: App {
    
    @StateObject var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cartManager)
        }
    }
}
