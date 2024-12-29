import SwiftUI

struct AnswerView: View {
    let coin: Coin
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let photoURL = coin.photoURL,
                   let url = URL(string: photoURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Group {
                    infoRow(title: "Name", value: coin.name)
                    infoRow(title: "Reference Price", value: "\(coin.referencePrice) \(coin.currency)")
                    infoRow(title: "Issuer", value: coin.issuer)
                    infoRow(title: "Type", value: coin.type)
                    infoRow(title: "Years", value: coin.years)
                    infoRow(title: "Value", value: "\(coin.value) \(coin.currency)")
                    infoRow(title: "Composition", value: coin.composition)
                    infoRow(title: "Weight", value: "\(coin.weight) grams")
                    infoRow(title: "Thickness", value: "\(coin.thickness) mm")
                }
            }
            .padding()
        }
        .navigationTitle("Coin Details")
    }
    
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
} 