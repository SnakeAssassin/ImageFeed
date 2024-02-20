import UIKit


final class ImagesListViewController: UIViewController {
    
    // MARK: Properties
    
    private let photosName: [String] = Array(0..<20).map {"\($0)"}
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
