import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
    
    
    
///    Если вы создаете экземпляр TabBarController программно, метод awakeFromNib() не будет вызываться, так как он предназначен для настройки объектов, загруженных из Interface Builder.
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        tabBar.barTintColor = .ypBlack
//        tabBar.tintColor = .ypWhite
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
//        let profileViewController = ProfileViewController()
//        profileViewController.tabBarItem = UITabBarItem(title: nil,
//                                                        image: UIImage(named: "tab_profile_active"),
//                                                        selectedImage: nil)
//        self.viewControllers = [imagesListViewController, profileViewController]
//    }
//}
