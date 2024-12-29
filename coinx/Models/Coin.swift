import Foundation

struct Coin: Identifiable, Codable {
    let id: UUID
    let name: String
    let referencePrice: Double
    let issuer: String
    let type: String
    let years: String
    let value: Double
    let currency: String
    let composition: String
    let weight: Double
    let thickness: Double
    let photoURL: String?
    let createdAt: Date
    
    init(id: UUID = UUID(), 
         name: String,
         referencePrice: Double,
         issuer: String,
         type: String,
         years: String,
         value: Double,
         currency: String,
         composition: String,
         weight: Double,
         thickness: Double,
         photoURL: String? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.referencePrice = referencePrice
        self.issuer = issuer
        self.type = type
        self.years = years
        self.value = value
        self.currency = currency
        self.composition = composition
        self.weight = weight
        self.thickness = thickness
        self.photoURL = photoURL
        self.createdAt = createdAt
    }
} 