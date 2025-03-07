import SwiftUI

struct AppEntry: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            DynamicListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
        }
    }
}

struct AppEntry_Previews: PreviewProvider {
    static var previews: some View {
        AppEntry()
    }
}
