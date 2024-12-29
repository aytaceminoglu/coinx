import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey
        case invalidValue
    }
    
    private static func getConfigValue(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        return dict[key] as? String
    }
    
    static var openAIApiKey: String {
        return getConfigValue(for: "OPENAI_API_KEY") ?? ""
    }
    
    static var supabaseUrl: String {
        return getConfigValue(for: "SUPABASE_URL") ?? "https://ypodhxydtuweupfrnpse.supabase.co"
    }
    
    static var supabaseKey: String {
        return getConfigValue(for: "SUPABASE_KEY") ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlwb2RoeHlkdHV3ZXVwZnJucHNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0NzA1MjYsImV4cCI6MjA1MTA0NjUyNn0.k8UTCCDPjgjJGJ8fin4vp64m5GwjTpHXzzZgH2_S8IE"
    }
} 