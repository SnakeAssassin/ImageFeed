import UIKit
import WebKit


// MARK: - WebView Controller Delegate

protocol WebViewViewControllerDelegate: AnyObject {

    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)

    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}


// MARK: - WebView Controller

final class WebViewViewController: UIViewController, WKNavigationDelegate  {
    
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: Private properties
    
    fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        
        /// Делегат navigationDelegate предоставляет методы, которые позволяют отслеживать события навигации, такие как начало и завершение загрузки страницы, обработка ошибок, получение запросов на аутентификацию и другие связанные с навигацией события.
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
        progressView.progressTintColor = UIColor(named: "YP Black")
        progressView.trackTintColor = UIColor(named: "YP Gray")
        return progressView
    }()
    
    
    // MARK: Actions
    
    @objc func didTapButton() {
        delegate?.webViewViewControllerDidCancel(self)
        print("Закрываю Web View")
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        loadURLWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписка через KVO
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        updateProgress()   
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear called")
        
        // Отписка через KVO
        webView.removeObserver(self,
                               forKeyPath: #keyPath(WKWebView.estimatedProgress),
                               context: nil)
    }    
}


// MARK: - Navigation Action

extension WebViewViewController {
    
    // Разрешает или прекращает навигацию (загрузка страницы или другое действие будет отменено)
    
    /// `webView выбор WebView`, если делегат принимает сообщения от нескольких WKWebView.
    /// `navigationAction: WKNavigationAction` - этот объект содержит информацию о том, что явилось причиной навигационных действий.
    /// `decisionHandler` -  передаётся замыкание: `cancel` — отменить навигацию, `allow` — разрешить навигацию,`download` — разрешить загрузку.
    internal func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ){
        if let code = code(from: navigationAction) { //1
            print("WebViewViewController: code принят. Передаю в AuthViewController")
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel) // Если код успешно получен, отменяем навигационное действие
            navigationController?.popViewController(animated: true)
        } else {
            decisionHandler(.allow) // Если код не получен, разрешаем навигационное действие.
        }
    }
    
    // Проверяем что код из реквеста получен
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}


// MARK: - Update Progress

extension WebViewViewController {
    
    // Обработчик обновлений KVO
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

// MARK: - Create View

extension WebViewViewController {
    
    private func createView() {
        setBackButton()
        setWebView()
        setProgressView()
        view.backgroundColor = UIColor(named: "YP White")
    }
    
    private func setBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }

    private func setWebView() {
        
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

extension WebViewViewController {
    
    private func loadURLWebView() {
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        // https://unsplash.com/oauth/authorize/?client_id=AccesKey&redirect_uri=RedirectURI&response_type=code&scope=AccessScope
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
