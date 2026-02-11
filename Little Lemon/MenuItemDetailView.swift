
import SwiftUI

struct MenuItemDetailView: View {
    
    let item: MenuItem
    
    @EnvironmentObject var cart: CartManager
    @Environment(\.dismiss) var dismiss
    
    @State private var quantity = 1
    @State private var showAlert = false
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 260)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(item.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(item.price)
                        .font(.title2)
                        .foregroundColor(Color("PrimaryGreen"))
                        .bold()
                    
                    Text(item.description)
                        .foregroundColor(.gray)
   
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                        .padding(.vertical)
 
                    Button {
                        cart.add(item: item, quantity: quantity)
                        showAlert = true
                    } label: {
                        Text("Add to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("PrimaryGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Added to cart!", isPresented: $showAlert) {
            
            Button("OK") {
                dismiss()
            }
        }
    }
}

