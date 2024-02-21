import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2TokenKey"
    
    internal var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let token = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
            guard isSuccess else { return }
        }
    }
    
    internal func removeToken() {
        _ = KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
    
    private init() { }
}
