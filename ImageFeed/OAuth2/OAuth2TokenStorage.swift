import UIKit

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2TokenKey"

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey) 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    private init() { }
}
