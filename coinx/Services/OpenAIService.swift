import Foundation

class OpenAIService {
    private let apiKey: String
    @Published var storageService = StorageService()
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func analyzeImage(imageUrl: String) async throws -> Coin {
        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        let prompt = """
        I am developing a coin identifier application. The application should process the information provided by the user and return a JSON response. The response must include the following fields in the same order:
        
        - **name**: The name of the coin (e.g., "Liberty Coin").
        - **reference_price**: The reference price of the coin (e.g., 250 USD).
        - **issuer**: The country or authority that issued the coin (e.g., "USA").
        - **type**: The type of the coin (e.g., "Commemorative", "Circulating").
        - **years**: The years the coin was produced (e.g., "2000-2023").
        - **value**: The nominal value of the coin (e.g., "1").
        - **currency**: The currency of the coin (e.g., "USD").
        - **composition**: The material composition of the coin (e.g., "Gold, Silver").
        - **weight**: The weight of the coin (e.g., "31.1 grams").
        - **thickness**: The thickness of the coin (e.g., "2.5 mm").
        
        If any information is unavailable, the application should attempt to infer or estimate the missing values based on patterns, standards, or related data. The JSON output format must always maintain the same field order. Examples:
        
        For complete data:
        ```json
        {
        "name": "Liberty Coin",
        "reference_price": "250 USD",
        "issuer": "USA",
        "type": "Commemorative",
        "years": "2000-2023",
        "value": "1",
        "currency": "USD",
        "composition": "Gold",
        "weight": "31.1 grams",
        "thickness": "2.5 mm"
        }
        """
        
        let payload: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": imageUrl
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 500,
            "response_format": ["type": "json_object"]
        ]
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Parse OpenAI response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String,
              let responseData = content.data(using: .utf8),
              let coinData = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
        }
        
        // Extract values and create Coin object
        let coin = Coin(
            name: coinData["name"] as? String ?? "Unknown",
            referencePrice: extractPrice(from: coinData["reference_price"] as? String ?? "0"),
            issuer: coinData["issuer"] as? String ?? "Unknown",
            type: coinData["type"] as? String ?? "Unknown",
            years: coinData["years"] as? String ?? "Unknown",
            value: extractPrice(from: coinData["value"] as? String ?? "0"),
            currency: coinData["currency"] as? String ?? "USD",
            composition: coinData["composition"] as? String ?? "Unknown",
            weight: extractWeight(from: coinData["weight"] as? String ?? "0"),
            thickness: extractThickness(from: coinData["thickness"] as? String ?? "0"),
            photoURL: imageUrl
        )
        
        // Save the coin
        await MainActor.run {
            storageService.saveCoin(coin)
        }
        
        return coin
    }
    
    private func extractPrice(from string: String) -> Double {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return Double(numbers.joined()) ?? 0
    }
    
    private func extractWeight(from string: String) -> Double {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return Double(numbers.joined()) ?? 0
    }
    
    private func extractThickness(from string: String) -> Double {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return Double(numbers.joined()) ?? 0
    }
} 