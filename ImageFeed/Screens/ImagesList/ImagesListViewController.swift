import UIKit
import ProgressHUD
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: Properties
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    // Форматтер Date вида 01 января 2000
    private let dateFormatter: DateFormatter = {
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
    
    // MARK: Methods
    
    private func dateToString(from date: Date?) -> String {
        if let date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
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
        let date = dateToString(from: photos[indexPath.row].createdAt)
        cell.configCell(with: imageURL, isLiked: isLiked, createdAt: date) { [weak self] result in
            guard self != nil else { return }
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
        print("[tableView/willDisplay] Текущая ячейка: \(indexPath.row)")
        print("[tableView/willDisplay] Всего ячеек: \(imagesListService.photos.count)")
        if indexPath.row + 1 == imagesListService.photos.count {
            print("[tableView/willDisplay]: run fetchPhotosNextPage()")
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
        present(navigationController, animated: true, completion: nil)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        // Узнали индекс ячейки в которой нажат лайк
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // Получили лайкнутое фото по индексу
        let photo = photos[indexPath.row]
        
        // Текущее состояние лайка до нажатия и инвертируем после нажатия
        let like = !photo.isLiked
        // Показали загрузку-блокировку от нажатия
        UIBlockingProgressHUD.show()
        
        // Отправляем POST-запрос на сервер на изменение с новым лайком
        imagesListService.changeLike(photoId: photo.id, isLike: like) { result in
            switch result {
            case .success(let isLiked):
                
                // Синхронизируем [ImagedListVC/Photos]
                self.photos = self.imagesListService.photos
                
                print("Пришел ответ от сервера: ")
                print("Лайк который мы отправляли: \(like)")
                print("Лайк который записался на сервере: \(isLiked)")
                print("[ImagedListVC/Photos] Состояние лайка: \(self.photos[indexPath.row].isLiked)")
                print("[ImagedListService/Photos] Состояние лайка: \(ImagesListService.shared.photos[indexPath.row].isLiked)")
                
                // Обновляем картинку лайка с новым значением (сервер)
                cell.changeLikeButtonImageFor(state: isLiked)
                
                
                // Убираем загрузку и блокировку
                UIBlockingProgressHUD.dismiss()
                
            case .failure (let error):
                UIBlockingProgressHUD.dismiss()
                print("Неудача! Лайк не поставлен: \(error)")
                // TODO: show alert
                return
            }
        }
    }
}



//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero)
//        tableView.backgroundColor = .ypBlack
//        tableView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        tableView.separatorStyle = .none
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//
//    private func setTableView() {
//        view.addSubview(tableView)
//        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        //tableView.registerReusableCell(cellType: ImagesListCell.self)
//    }

//        setTableView()
