import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
                    .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.primary)
                    })
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("CoinX")
                                .font(.headline)
                                .bold()
                        }
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationView {
                HistoryView()
                    .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.primary)
                    })
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("CoinX")
                                .font(.headline)
                                .bold()
                        }
                    }
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
        }
    }
} 