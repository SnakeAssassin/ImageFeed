import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: Properties
    
    private let photosName: [String] = Array(0..<20).map {"\($0)"}
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
//    private let oauth2TokenStorage = OAuth2TokenStorage.shared
//    private let imagesListService = ImagesListService.shared
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let token = oauth2TokenStorage.token {
//            fetchPhotosNextPage(token: token)
//        } else {
//            return
//        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: Methods
    
    // Передаем сегвею нужную картинку при нажатии на нее из таблицы
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == ShowSingleImageSegueIdentifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        if let viewController = segue.destination as? SingleImageViewController, let indexPath = sender as? IndexPath {
            let image = UIImage(named: photosName[indexPath.row])
            viewController.setImage(image: image)
        }
    }
}

// MARK: - Extension Methods

extension ImagesListViewController: UITableViewDataSource {
    
    // Устанавливаем количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    // Наполняем ячейку данными
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Из всех зарегистрированных ячеек в таблице, вернуть ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let imageName = photosName[indexPath.row]
        let isLiked = indexPath.row % 2 == 0
        cell.configCell(with: imageName, isLiked: isLiked)
        
        return cell
    }
    
//    // Метод вызывается прямо перед тем, как ячейка таблицы будет показана на экране
//    func tableView(_ tableView: UITableView,
//                   willDisplay cell: UITableViewCell,
//                   forRowAt indexPath: IndexPath
//    ) {
//        // Проверяем совпадает ли количество ячеек с полученными данными фото
//        if indexPath.row + 1 == imagesListService.photos.count {
//            
//            
//            if let token = oauth2TokenStorage.token {
//                imagesListService.fetchPhotosNextPage(token)  { [weak self] result in
//                    guard let self = self else { return }
//                    switch result {
//                    case .success(let photos):
//                        print("[SplashViewController/fetchPhotosNextPage()]: Данные фотографий получены - \(photos)")
//                        self.photosArr = photos
//                    case .failure(let error):
//                        print("[SplashViewController/fetchPhotosNextPage()]: Данные фотографий не получены - \(error)")
//                        //self.showAlertError()
//                        break
//                    }
//                }
//            } else {
//                return
//            }
//            
//            
//        }
//    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    // Открываем картинку в новом экране через segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    // Динамическая высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let k = (tableView.bounds.width - imageInsets.left - imageInsets.right) / image.size.width
        
        return image.size.height * k + imageInsets.top + imageInsets.bottom
    }
}

/*extension ImagesListViewController {
    
    private func fetchPhotosNextPage(token: String) {
        print("Вызываю fetchPhotosNextPage")
        imagesListService.fetchPhotosNextPage(token)  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                print("[SplashViewController/fetchPhotosNextPage()]: Данные фотографий получены - \(photos)")
                self.photosArr = photos
            case .failure(let error):
                print("[SplashViewController/fetchPhotosNextPage()]: Данные фотографий не получены - \(error)")
                self.showAlertError()
                break
            }
        }
    }
    
    private func showAlertError() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось получить ленту изображений",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}*/
