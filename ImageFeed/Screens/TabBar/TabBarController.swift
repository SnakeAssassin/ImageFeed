import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        // вызывается системой сразу, как только объект (TabBarController) был создан и настроен согласно состоянию из Storyboard.
        super.awakeFromNib()
        
        // фон
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        // Создаем экземпляры контроллеров
//        let imagesListViewController = ImagesListViewController()
//        imagesListViewController.tabBarItem = UITabBarItem(
//            title: nil,
//            image: UIImage(named: "tab_editorial_active"),
//            selectedImage: nil
//        )
                let imagesListViewController = storyboard.instantiateViewController(
                    withIdentifier: "ImagesListViewController"
                )
        
        // Через экземпляр класса
        let profileViewController = ProfileViewController()
        
        // добавляем таб бар
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil

        )
        
        
        // Через идентификатор в StoryboardID
        //        let profileViewController = storyboard.instantiateViewController(
        //            withIdentifier: "ProfileViewController"
        //        )
        
        // Устанавливаем контроллеры в tab bar controller
        self.viewControllers = [imagesListViewController, profileViewController]
        
        self.selectedIndex = 0
    }
}

//final class TabBarController: UITabBarController {
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        print("awakeFromNib")
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//
//        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
//        
//        let profileViewController = ProfileViewController()
//       
////        profileViewController.tabBarItem = UITabBarItem(
////            title: nil,
////            image: UIImage(named: "tab_profile_active"),
////            selectedImage: nil)
//        
//        self.viewControllers = [imagesListViewController, profileViewController]
//
//    }
//}
