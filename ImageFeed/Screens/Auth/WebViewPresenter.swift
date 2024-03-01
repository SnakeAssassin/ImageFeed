import Foundation

// MARK: - WebViewPresenter Protocol

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

// MARK: - WebView Presenter

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: Public Properties

    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol

    // MARK: Initializers
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    // MARK: Public Methods
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let hideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(hideProgress)
    }
    

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}


