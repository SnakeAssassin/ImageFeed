import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2TokenKey"
    
    internal var token: String? {
        get {
            //return UserDefaults.standard.string(forKey: tokenKey)
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            //UserDefaults.standard.set(newValue, forKey: tokenKey)
            guard let token = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
            guard isSuccess else { return }
        }
    }
    
    internal func removeToken() {
            
            // Удаляем токен из Keychain
            _ = KeychainWrapper.standard.removeObject(forKey: tokenKey)
        }
    
    private init() { }
}
