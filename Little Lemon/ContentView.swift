import SwiftUI


struct ContentView: View {
    
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("email") private var email = ""
    
    var body: some View {
        if firstName.isEmpty || email.isEmpty {
            OnboardingView()
        } else {
            HomeView()
        }
    }
}

struct OnboardingView: View {
    
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("email") private var email = ""
    
    @State private var tempName = ""
    @State private var tempEmail = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        VStack(spacing: 20) {
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .padding(.top)
            
            HeroStatic()
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Name *")
                TextField("Enter your name", text: $tempName)
                    .textFieldStyle(.roundedBorder)
                
                Text("Email *")
                TextField("Enter your email", text: $tempEmail)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                
                Button {
                    
                    guard !tempName.isEmpty else {
                        alertMessage = "Please enter your name."
                        showAlert = true
                        return
                    }
                    
                    guard isValidEmail(tempEmail) else {
                        alertMessage = "Please enter a valid email."
                        showAlert = true
                        return
                    }
                    
                    firstName = tempName
                    email = tempEmail
                    
                } label: {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryYellow"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }

            }
            .padding()
            
            Spacer()
        }
        .alert("Please fill in all fields", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
func isValidEmail(_ email: String) -> Bool {
    
    let emailRegex =
    #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    return NSPredicate(
        format: "SELF MATCHES %@",
        emailRegex
    ).evaluate(with: email)
}



struct HomeView: View {
    
    @State private var searchText = ""
    @State private var selectedCategory: Category? = nil
    
    var filteredItems: [MenuItem] {
        menuItems.filter { item in
            
            let matchesCategory =
            selectedCategory == nil ||
            item.category == selectedCategory
            
            let matchesSearch =
            searchText.isEmpty ||
            item.title.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    TopNavBar()
                    
                    HeroSearch(searchText: $searchText)
                    
                    CategorySection(selectedCategory: $selectedCategory)
                    
                    MenuList(items: filteredItems)
                }
            }
            .background(Color("LightGray").opacity(0.15))
        }
    }
}


struct ProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("firstName") private var storedFirst = ""
    @AppStorage("lastName") private var storedLast = ""
    @AppStorage("email") private var storedEmail = ""
    @AppStorage("phone") private var storedPhone = ""
    
    @State private var first = ""
    @State private var last = ""
    @State private var email = ""
    @State private var phone = ""
    
    @State private var orderStatuses = true
    @State private var passwordChanges = true
    @State private var specialOffers = true
    @State private var newsletter = true
    @State private var showSaveAlert = false

    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                header
                
                profileCard
                
            }
            .padding(.top)
        }
        .background(Color("LightGray").opacity(0.2))
        .onAppear(perform: loadUser)
        .alert("Changes saved!", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) {}
        }

    }
 
    var header: some View {
        HStack {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("PrimaryGreen"))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            Spacer()
            
            Image("Profile")
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }

    var profileCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            Text("Personal information")
                .font(.title3)
                .bold()
            
            Text("Avatar")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                
                Image("Profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                Button("Change") {}
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color("PrimaryGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Button("Remove") {}
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray)
                    )
            }
            
            LabelField(title: "First name", text: $first)
            LabelField(title: "Last name", text: $last)
            LabelField(title: "Email", text: $email)
            LabelField(title: "Phone number", text: $phone)
            
            Text("Email notifications")
                .font(.headline)
                .padding(.top, 10)
            
            ToggleRow(title: "Order statuses", isOn: $orderStatuses)
            ToggleRow(title: "Password changes", isOn: $passwordChanges)
            ToggleRow(title: "Special offers", isOn: $specialOffers)
            ToggleRow(title: "Newsletter", isOn: $newsletter)
            
            Button {
                storedFirst = ""
                storedLast = ""
                storedEmail = ""
                storedPhone = ""
            } label: {
                Text("Log out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryYellow"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            HStack {
                
                Button("Discard changes") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )

                
                Button("Save changes") {
                    
                    storedFirst = first
                    storedLast = last
                    storedEmail = email
                    storedPhone = phone
                    
                    showSaveAlert = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("PrimaryGreen"))
                .foregroundColor(.white)
                .cornerRadius(10)

            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 8)
        .padding(.horizontal)
    }
    
    func loadUser() {
        first = storedFirst
        last = storedLast
        email = storedEmail
        phone = storedPhone
    }
}

struct TopNavBar: View {
    
    @EnvironmentObject var cart: CartManager
    
    var body: some View {
        HStack {
   
            NavigationLink(destination: CartView()) {
                
                ZStack(alignment: .topTrailing) {
                    
                    Image(systemName: "cart")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    if cart.itemCount > 0 {
                        Text("\(cart.itemCount)")
                            .font(.caption2)
                            .padding(6)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            }
            
            Spacer()

            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            Spacer()

            NavigationLink(destination: ProfileView()) {
                Image("Profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
}

struct HeroStatic: View {
    var body: some View {
        ZStack {
            Color("PrimaryGreen")
            heroContent
        }
        .frame(height: 300)
    }
}

struct HeroSearch: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            Color("PrimaryGreen")
            
            VStack(alignment: .leading, spacing: 20) {
                heroContent
                
                TextField("Search menu", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .frame(height: 340)
    }
}

var heroContent: some View {
    HStack {
        VStack(alignment: .leading) {
            Text("Little Lemon")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(Color("PrimaryYellow"))
            
            Text("Chicago")
                .foregroundColor(.white)
            
            Text("We are a family owned Mediterranean restaurant,focused on traditional recepies served with a modern twist")
                .foregroundColor(.white)
                .font(.subheadline)
        }
        
        Spacer()
        
        Image("Hero image")
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 140)
            .clipped()
            .cornerRadius(12)
    }
}

enum Category: String, CaseIterable {
    case starters = "Starters"
    case mains = "Mains"
    case desserts = "Desserts"
    case drinks = "Drinks"
}

struct CategorySection: View {
    @Binding var selectedCategory: Category?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("ORDER FOR DELIVERY!")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    CategoryButton(
                        title: "All",
                        selected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    
                    ForEach(Category.allCases, id: \.self) { cat in
                        CategoryButton(
                            title: cat.rawValue,
                            selected: selectedCategory == cat
                        ) {
                            selectedCategory = cat
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct CategoryButton: View {
    
    let title: String
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    selected
                    ? Color("PrimaryGreen")
                    : Color("SecondaryGreen").opacity(0.2)
                )
                .foregroundColor(selected ? .white : Color("PrimaryGreen"))
                .clipShape(Capsule())
        }
    }
}

struct MenuList: View {
    
    let items: [MenuItem]
    
    var body: some View {
        LazyVStack {
            
            ForEach(items) { item in
                
                NavigationLink(destination: MenuItemDetailView(item: item)) {
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            
                            Text(item.title)
                                .font(.headline)
                            
                            Text(item.description)
                                .font(.subheadline)
                            
                            Text(item.price)
                                .foregroundColor(Color("PrimaryGreen"))
                        }
                        
                        Spacer()
                        
                        Image(item.image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .buttonStyle(.plain)
                
                Divider()
            }
        }
        .background(Color.white)
    }
}


struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let price: String
    let image: String
    let category: Category
}

let menuItems = [
    MenuItem(title: "Greek Salad", description: "Crispy lettuce and feta.", price: "$12.99", image: "Greek salad", category: .starters),
    MenuItem(title: "Bruschetta", description: "Grilled bread with tomatoes.", price: "$7.99", image: "Bruschetta", category: .starters),
    MenuItem(title: "Grilled Fish", description: "Catch of the day.", price: "$20.00", image: "Grilled fish", category: .mains),
    MenuItem(title: "Pasta", description: "Penne with tomato sauce.", price: "$18.99", image: "Pasta", category: .mains),
    MenuItem(title: "Lemon Dessert", description: "Ricotta lemon cake.", price: "$6.99", image: "Lemon dessert", category: .desserts)
]

struct LabelField: View {
    
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                )
        }
    }
}

struct ToggleRow: View {
    
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(title, isOn: $isOn)
            .tint(Color("PrimaryGreen"))
    }
}

#Preview {
    ContentView()
}
