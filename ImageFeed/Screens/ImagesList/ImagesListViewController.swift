import UIKit
import ProgressHUD
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: Properties
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let photosName: [String] = Array(0..<10).map {"\($0)"}
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListService.fetchPhotosNextPage()
        startObserver()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func startObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        UIBlockingProgressHUD.show()
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
    
    // 1. Устанавливаем количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return photosName.count
        return photos.count
    }
    
    // 2. Наполняем каждую ячейку внутри таблицы данными
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Из всех зарегистрированных ячеек в таблице, вернуть ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        //let imageName = photosName[indexPath.row]
        let imageURL = photos[indexPath.row].thumbImageURL
        let isLiked = indexPath.row % 2 == 0
        cell.configCell(with: imageURL, isLiked: isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // Перерисовываем ячейку после загрузки изображения
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                return
            }
        }
        return cell
    }
    
    // 3. Вычисление динамической высоты ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let k = (tableView.bounds.width - imageInsets.left - imageInsets.right) / imageSize.width
        return imageSize.height * k + imageInsets.top + imageInsets.bottom
    }
    
    // 4. Обновить таблицу при получении загруженных данных
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
        UIBlockingProgressHUD.dismiss()
    }
    
    // 5. Добавить новые строки с новыми загруженными данными
    // Метод вызывается прямо перед тем, как ячейка таблицы будет показана на экране
    // При каждой прокрутке и отображении новой ячейки он тоже вызывается
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        // Проверяем совпадает ли количество ячеек с полученными данными фото
        print("indexPath.row: \(indexPath.row)")
        print("imagesListService.photos.count: \(imagesListService.photos.count)")
        if indexPath.row + 1 == imagesListService.photos.count {
            
            
            print("[tableView/willDisplay]: run fetchPhotosNextPage()")
            imagesListService.fetchPhotosNextPage()
        }
        print("end")
    }
}

extension ImagesListViewController: UITableViewDelegate {
    // Открываем картинку в новом экране через segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
}
