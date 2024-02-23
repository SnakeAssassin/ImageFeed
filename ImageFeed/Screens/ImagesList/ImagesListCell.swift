import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: Public properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: Private properties
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           
           // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        mainImageView.kf.cancelDownloadTask()
       }
}

    // MARK: - Public methods

extension ImagesListCell {
    
    func configCell(with imageURL: String, isLiked: Bool, completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        
        
        if let url = URL(string: imageURL) {
            mainImageView.kf.indicatorType = .activity
            mainImageView.kf.setImage(with: url,
                                      placeholder: UIImage(named: "Stub_cell"),
                                      completionHandler: { result in
                switch result {
                case.success(let value):
                    completion(.success(value))
                case.failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            })
        }
        dateLabel.text = dateFormatter.string(from: Date())
        likeButton.setTitle("", for: .normal)
        changeLikeButtonImageFor(state: isLiked)
        mainImageView.layer.cornerRadius = 16
        mainImageView.layer.masksToBounds = true
    }
}

    // MARK: - Private methods

private extension ImagesListCell {
    
    func changeLikeButtonImageFor(state isLiked: Bool) {
        let imageName = isLiked ? "like_button_active" : "like_button_no_active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
