enum AppConfig {
    static var baseUrl: String {
        return configuration(.baseUrl)
    }
    
    static var apiKey: String {
        configuration(.apiKey)
    }
    
    private static func configuration(_ key: Plist) -> String {
        if let infoDictionary = Bundle.main.infoDictionary {
            return infoDictionary[key.value] as? String ?? "\(key.value)"
        } else {
            fatalError("Unable to load plist file")
        }
    }
    
}