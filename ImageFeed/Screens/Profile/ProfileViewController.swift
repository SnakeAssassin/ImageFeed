import UIKit
import Kingfisher

// MARK: - Profile View Controller Protocol

public protocol ProfileViewControllerProtocol: AnyObject {
    
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func updateAvatar()
}

// MARK: - Profile View Controller

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: Properties
    
    var presenter: ProfilePresenterProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "LogoutButton"
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(Self.didTapButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Actions
    
    @objc func didTapButton() {
        showLogoutAlert()
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setView()
    }
    
    // MARK: Logout Alert

    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let alertActionYes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            presenter?.cleanTokenAndCookie()
        }
        alertActionYes.accessibilityIdentifier = "logoutAlertYesButton" 
        alert.addAction(alertActionYes)
        let alertActionNo = UIAlertAction(title: "Нет", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        alert.addAction(alertActionNo)
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Update Profile

extension ProfileViewController {
    
    func updateAvatar() {
        profileImageView.kf.indicatorType = .activity
        let url = presenter?.getImageURL()
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "Stub_profile"))
    }
    
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

// MARK: - Create View

extension ProfileViewController {
    
    private func setView() {
        
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(loginLabel)
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
