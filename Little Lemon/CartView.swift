import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cart: CartManager
    
    @State private var showCheckoutAlert = false
    
    var body: some View {
        
        VStack {
            
            if cart.items.isEmpty {
                
                Spacer()
                Text("Your cart is empty")
                    .font(.title2)
                Spacer()
                
            } else {
                
                List {
                    
                    ForEach(Array(cart.items.keys), id: \.self) { item in
                        
                        HStack {
                            Text(item.title)
                            
                            Spacer()
                            
                            Text("x\(cart.items[item] ?? 0)")
                            
                            Text(item.price)
                        }
                    }
                    
                    HStack {
                        Text("Total")
                            .bold()
                        
                        Spacer()
                        
                        Text("$\(cart.total, specifier: "%.2f")")
                            .bold()
                    }
                }
                
                Button {
                    showCheckoutAlert = true
                    cart.clearCart()
                    
                } label: {
                    Text("Checkout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                }
            }
        }
        .navigationTitle("Cart")
        .alert("Your food has been purchased and will be delivered soon. Check your email for confirmation.", isPresented: $showCheckoutAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
//
//  CartView.swift
//  Little Lemon
//
//  Created by Jesus Cervantes on 2/11/26.
//

import Foundation
