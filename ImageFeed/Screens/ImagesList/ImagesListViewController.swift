import UIKit
import ProgressHUD
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: Properties
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.imagesListService.fetchPhotosNextPage()
    }
}

// MARK: - Extension Methods

extension ImagesListViewController: UITableViewDataSource {
    
    // 1. Устанавливаем количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    // 2. Наполняем каждую ячейку внутри таблицы данными
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Из всех зарегистрированных ячеек в таблице, вернуть ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let imageURL = photos[indexPath.row].thumbImageURL
        let isLiked = photos[indexPath.row].isLiked
        let createdAt = photos[indexPath.row].createdAt == nil ? "" : dateFormatter.string(from: photos[indexPath.row].createdAt!)
        cell.configCell(with: imageURL, isLiked: isLiked, createdAt: createdAt) { [weak self] result in
            guard let self else { return }
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
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: SingleImageViewControllerDelegate {
    func dismissSingleImageViewControllerDelegate(_ vc: SingleImageViewController) {
        dismiss(animated: true)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    // 6. При нажатии на ячейку - открыть картинку в новом экране через segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Показать картинку в SingleImageViewController()
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.delegate = self
        let imageURL = photos[indexPath.row].largeImageURL
        singleImageViewController.imageURL = imageURL
        let navigationController = UINavigationController(rootViewController: singleImageViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)
        present(navigationController, animated: true, completion: nil)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {

        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let like = !photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: like) { result in
            switch result {
            case .success(let isLiked):
                self.photos = self.imagesListService.photos
                cell.changeLikeButtonImageFor(state: isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure (let error):
                UIBlockingProgressHUD.dismiss()
                print(error.localizedDescription)
                return
            }
        }
    }
}
