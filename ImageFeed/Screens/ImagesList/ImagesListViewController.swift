import UIKit
import ProgressHUD
import Kingfisher

// MARK: - Profile View Controller Protocol

public protocol ImagesListControllerProtocol: AnyObject {
    
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(indexPath: [IndexPath])
}

final class ImagesListViewController: UIViewController, ImagesListControllerProtocol {
    
    // MARK: Properties
    
    var presenter: ImagesListPresenterProtocol?

    private var imagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        UIBlockingProgressHUD.show()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - Extension Methods

extension ImagesListViewController: UITableViewDataSource {
    
    // 0. Обновить таблицу при получении загруженных данных
    func updateTableViewAnimated(indexPath: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPath, with: .automatic)
        }
        UIBlockingProgressHUD.dismiss()
    }
    
    // 1. Устанавливаем количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotosCount() ?? 0
    }
    
    // 2. Наполняем каждую ячейку внутри таблицы данными
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Из всех зарегистрированных ячеек в таблице, вернуть ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        if let cellData = presenter?.getCellData(indexPath: indexPath) {
            cell.configCell(with: cellData.imageURL,
                            isLiked: cellData.isLiked,
                            createdAt: cellData.createdAt)
            { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    // Перерисовываем ячейку после загрузки изображения
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure:
                    return
                }
            }
        }
        return cell
    }
    
    // 3. Вычисление динамической высоты ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else { return 0 }
        let photo = presenter.getPhoto(indexPath: indexPath)
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let k = (tableView.bounds.width - imageInsets.left - imageInsets.right) / photo.size.width
        return photo.size.height * k + imageInsets.top + imageInsets.bottom
    }
    
    // 4. Добавить новые строки с новыми загруженными данными, если последняя фотография
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath
    ) {
        guard let presenter = presenter else { return }
        presenter.shouldFetchPhotosNextPage(lastImage: indexPath.row, getOnlyFirstPageIn: false)
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
        guard let presenter = presenter else { return }
        let photo = presenter.getPhoto(indexPath: indexPath)
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.delegate = self
        singleImageViewController.imageURL = photo.largeImageURL
        let navigationController = UINavigationController(rootViewController: singleImageViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)
        present(navigationController, animated: true, completion: nil)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell),
              let presenter = presenter else { return }
        UIBlockingProgressHUD.show()
        presenter.changeLike(indexPath: indexPath) { result in
            switch result {
            case .success(let isLiked):
                cell.changeLikeButtonImageFor(state: isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error.localizedDescription)
                return
            }
        }
    }
}
