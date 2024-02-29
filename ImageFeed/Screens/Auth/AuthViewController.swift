import UIKit

// MARK: - AuthViewController Delegate

protocol AuthViewControllerDelegate: AnyObject {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}


// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    // MARK: Private properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo_of_Unsplash")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return image
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypWhite
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.setTitleColor(.ypBlack, for: .normal)
        button.setTitleColor(.ypGray, for: .highlighted)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(Self.didTapButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Actions
    
    @objc private func didTapButton() {
        showWebViewController()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoImage()
        setLoginButton()
        view.backgroundColor = .ypBlack
    }
    
    // MARK: Create View
    
    private func setLogoImage() {
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setLoginButton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Prepare for Segue

extension AuthViewController {
    
    private func showWebViewController() {
        let webViewViewController = WebViewViewController()
        navigationController?.pushViewController(webViewViewController, animated: true)
        
        /// III. Соединяем вьюконтроллер и презентер между собой через протоколы
        let authHelper = AuthHelper()                       // Так как изменен инициализатор в WebViewPresenter, 
                                                            // то создаем экзепляр для передачи в webViewPresenter
        let webViewPresenter = WebViewPresenter(authHelper: authHelper) // Создаем экземпляр презентора
        webViewViewController.presenter = webViewPresenter  // Соединяем презентер контроллера с презентером()
        webViewPresenter.view = webViewViewController       // Соединяем вью презентера с контроллером
        webViewViewController.delegate = self
        
        
        webViewViewController.delegate = self
    }
}

// MARK: - AuthView Delegate

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

