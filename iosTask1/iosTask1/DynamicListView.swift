import SwiftUI

struct DynamicListView: View {
    @State private var items: [String] = UserDefaults.standard.stringArray(forKey: "items") ?? []
    @State private var newItem = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // TextField and Add Button
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
                
                // List of Items
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
    }
    
    // Delete item from list
    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItems()
    }
    
    // Save items to UserDefaults
    private func saveItems() {
        UserDefaults.standard.set(items, forKey: "items")
    }
}

struct DynamicListView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicListView()
    }
}
