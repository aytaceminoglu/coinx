import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                Button(action: {
                    // Feedback action
                }) {
                    Label("Feedback", systemImage: "envelope")
                }
                
                Button(action: {
                    if let url = URL(string: "itms-apps://apple.com/app/id{YOUR_APP_ID}") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label("Review", systemImage: "star")
                }
                
                Button(action: {
                    let activityVC = UIActivityViewController(
                        activityItems: ["Check out CoinX - The Coin Identifier App!"],
                        applicationActivities: nil
                    )
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first,
                       let rootVC = window.rootViewController {
                        rootVC.present(activityVC, animated: true)
                    }
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            Section {
                NavigationLink(destination: Text("Privacy Policy")) {
                    Label("Privacy Policy", systemImage: "lock.shield")
                }
                
                NavigationLink(destination: Text("Terms and Conditions")) {
                    Label("Terms and Conditions", systemImage: "doc.text")
                }
            }
        }
        .navigationTitle("Settings")
    }
} 