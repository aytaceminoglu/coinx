import SwiftUI

struct HistoryView: View {
    @StateObject private var storageService = StorageService()
    
    var body: some View {
        NavigationView {
            List(storageService.coins.sorted(by: { $0.createdAt > $1.createdAt })) { coin in
                NavigationLink(destination: AnswerView(coin: coin)) {
                    CoinHistoryRow(coin: coin)
                }
            }
            .navigationTitle("History")
        }
    }
}

struct CoinHistoryRow: View {
    let coin: Coin
    
    var body: some View {
        HStack(spacing: 12) {
            if let photoURL = coin.photoURL,
               let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.headline)
                Text("\(coin.value) \(coin.currency) • \(coin.type)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(coin.createdAt.formatted(.relative(presentation: .named)))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
} 