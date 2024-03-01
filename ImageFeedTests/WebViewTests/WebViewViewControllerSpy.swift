import ImageFeed
import Foundation

// 2.2.1 Используем вместо вьюконтроллера объект-дублёр WebViewViewControllerSpy
final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenterDidLoadRequestCalled: Bool = false
    
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        presenterDidLoadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
