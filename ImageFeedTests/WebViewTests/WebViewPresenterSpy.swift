import ImageFeed
import Foundation

// 1.2.1 Нам нужно, чтобы презентер мог проверять, что у него вызван метод viewDidLoad.
// Поэтому вместо WebViewPresenter будем использовать объект-дублёр.
final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    
    // Для реализации протокола
    var view: WebViewViewControllerProtocol?
    
    // Для реализации протокола
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    // Для реализации протокола
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    // Для реализации протокола
    func code(from url: URL) -> String? {
        return nil
    }
}
