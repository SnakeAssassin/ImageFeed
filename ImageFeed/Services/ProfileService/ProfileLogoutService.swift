import Foundation
import Kingfisher
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCache()
        cleanCookies()
        cleanToken()
        
        // Меняем root-controller
        guard let window = UIApplication.shared.windows.first else {
            print("[SplashViewController/switchToTabBarController()]: Window Invalid Configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
    
    private func cleanCache() {
        let cache = ImageCache.default
        // Очищает кэш в оперативной памяти
        cache.clearMemoryCache()
        // Очищает дисковый кэш
        cache.clearDiskCache()
    }
    
    private func cleanToken() {
        OAuth2TokenStorage.shared.removeToken()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

