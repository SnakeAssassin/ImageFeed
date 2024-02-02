import Foundation


/// Класс для сохранения токена в UserDefaults

final class OAuth2TokenStorage {
    
    // Для вызова из других мест, чтобы не создавать экземпляры
    static let shared = OAuth2TokenStorage() // Синглтон
    
    private let tokenKey = "OAuth2TokenKey"

    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey) 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }

    //init() {}
}
