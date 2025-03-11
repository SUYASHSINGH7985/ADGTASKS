import SwiftUI

struct ContentView: View {
    @State private var labelText = "Hello, World!"
    @State private var buttonColors: [Color] = [.blue, .green, .orange, .purple, .red]
    @State private var currentColorIndex = 0
    @State private var textFieldInput = ""
    @State private var items: [String] = UserDefaults.standard.stringArray(forKey: "items") ?? []
    @State private var newItem = ""
    
    var body: some View {
        TabView {
         
            VStack(spacing: 20) {
               
                Text(labelText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
               
                Text("Character count: \(textFieldInput.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
             
                TextField("Enter text", text: $textFieldInput)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
               
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                       
                        labelText = textFieldInput.isEmpty ? "No text entered" : textFieldInput
                        
                       
                        if !buttonColors.isEmpty {
                            currentColorIndex = (currentColorIndex + 1) % buttonColors.count
                        }
                    }
                }) {
                    Text("Tap Me")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(buttonColors.isEmpty ? .blue : buttonColors[currentColorIndex]) 
                        .cornerRadius(10) 
                        .padding(.horizontal)
                }
                
              
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        labelText = "Hello, World!"
                        textFieldInput = ""
                        currentColorIndex = 0
                    }
                }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
           
            NavigationView {
                VStack(spacing: 20) {
                    
                    HStack {
                        TextField("Enter new item", text: $newItem)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        Button(action: {
                            if !newItem.isEmpty {
                                items.append(newItem)
                                newItem = ""
                                saveItems()
                            }
                        }) {
                            Text("Add")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                  
                    List {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                        }
                        .onDelete(perform: deleteItem)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                .navigationTitle("Dynamic List")
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
        }
    }
    

    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItems()
    }
    
   
    private func saveItems() {
        UserDefaults.standard.set(items, forKey: "items")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
