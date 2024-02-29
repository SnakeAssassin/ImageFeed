import UIKit
import WebKit


// MARK: - WebView Controller Delegate

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - WebView Controller Protocol

/// I. Объявляем протокол с переменной презентера
/// Тут будет ...
public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    /// 2. Выносим логику создания/отправки запроса в Presenter():
    /// 2.1 Создаем метод
    func load(request: URLRequest)
    
    /// 3.2 Выносим ответственность в протокол, чтобы презентер мог их вызвать
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
    
    ///
    
}
// MARK: - WebView Controller

final class WebViewViewController: UIViewController, WKNavigationDelegate, WebViewViewControllerProtocol  {
    
    /// Класс реализует протокол и создает переменную презентера
    var presenter: WebViewPresenterProtocol?
    /// 2.2 Реализуем метод
    func load(request: URLRequest) {
        webView.load(request)
    }

    
    
    
    
    // MARK: Private properties
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Backward_black"), for: .normal)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(Self.didTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .ypBlack
        progressView.trackTintColor = .ypGray
        return progressView
    }()
    
    
    // MARK: Actions
    
    @objc private func didTapButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        /// 2.5 Делаем Request URL через презентер
        presenter?.viewDidLoad()    // loadURLWebView() вынесли в presenter
        setupProgressObservation()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
}

// MARK: - Navigation Action

extension WebViewViewController {
    
    internal func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ){
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
            navigationController?.popViewController(animated: true)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
//    private func code(from navigationAction: WKNavigationAction) -> String? {
//        if let url = navigationAction.request.url,
//           let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
}

// MARK: - Update Progress Observer

extension WebViewViewController {
    private func setupProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 /// 3.5 Добавляем уведомление для презентера о том что WebView обновил значение estimatedProgress
                 self.presenter?.didUpdateProgressValue(webView.estimatedProgress)  // self.updateProgress() вынесли в presenter
                 
             })
    }
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    /// 3.1 Разбиваем метод для презентера
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
}

// MARK: - Create View

extension WebViewViewController {
    
    private func createView() {
        setBackButton()
        setWebView()
        setProgressView()
        view.backgroundColor = .ypWhite
    }
    
    private func setBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }
    
    private func setWebView() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setProgressView() {
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Request URL
//
//extension WebViewViewController {
//    
//    private func loadURLWebView() {
//        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AccessScope)
//        ]
//        
//        let url = urlComponents.url!
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//}
