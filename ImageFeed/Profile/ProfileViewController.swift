import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var profileImageView: UIImageView!
    
    @IBOutlet private var logoutButton: UIButton!
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBAction private func didTapLogoutButton() {
    }
}
