import UIKit
import Kingfisher

// MARK: - ImagesListCell Delegate

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {
    
    // MARK: Public properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
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
    
    @IBAction private func likeButtonClicked() {
        print("action!")
        delegate?.imageListCellDidTapLike(self)
    }
    
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

extension ImagesListCell {
    
    func changeLikeButtonImageFor(state isLiked: Bool) {
        print("[ImagesListCell/changeLikeButtonImageFor]: Вызван: \(isLiked)")
        let imageName = isLiked ? "like_button_active" : "like_button_no_active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

//lazy var cellImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = 16
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//lazy var likeButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
//        button.accessibilityIdentifier = "LikeButton"
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//lazy var dateLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//        setConstraints()
//    }
//
//private func setupView() {
//        backgroundColor = .ypBlack
//        selectionStyle = .none
//        
//        contentView.addSubview(cellImageView)
//        contentView.addSubview(likeButton)
//        contentView.addSubview(dateLabel)
//    }
//
//private func setConstraints() {
//        NSLayoutConstraint.activate([
//            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
//            
//            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 8),
//            dateLabel.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -8),
//            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8),
//            
//            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
//            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
//            likeButton.heightAnchor.constraint(equalToConstant: 42),
//            likeButton.widthAnchor.constraint(equalToConstant: 42)
//        ])
//    }
//@objc
//private func likeButtonClicked() {
//    print("action like")
//    delegate?.imageListCellDidTapLike(self)
//}
//
//cellImageView.kf.cancelDownloadTask()
