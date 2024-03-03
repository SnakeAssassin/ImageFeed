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
    
    private lazy var mainImageView = {
        let mainImageView = UIImageView()
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.cornerRadius = 16
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        return mainImageView
    }()
    
    private lazy var likeButton = {
        let likeButton = UIButton()
        likeButton.accessibilityIdentifier = "likeButtonIdentifier"
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(Self.likeButtonClicked), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var dateLabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor.ypWhite
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    // MARK: Initializaters
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setView()
    }
    
    required init?(coder: NSCoder) {
        //super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")   
    }
    
    // MARK: Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.kf.cancelDownloadTask()
        mainImageView.contentMode = .center
    }
    
    // MARK: IBAction
    
    @objc
    private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
}

// MARK: - Public methods

extension ImagesListCell {
    
    func configCell(with imageURL: String, isLiked: Bool, createdAt: String, completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        if let url = URL(string: imageURL) {
            mainImageView.kf.indicatorType = .activity
            mainImageView.kf.setImage(with: url,
                                      placeholder: UIImage(named: "Stub_cell"),
                                      completionHandler: { result in
                switch result {
                case.success(let value):
                    completion(.success(value))
                case.failure(let error):
                    completion(.failure(error))
                }
            })
        }
        dateLabel.text = createdAt
        changeLikeButtonImageFor(state: isLiked)
    }
    
    func changeLikeButtonImageFor(state isLiked: Bool) {
        let imageName = isLiked ? "like_button_active" : "like_button_no_active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

// MARK: - Private methods

extension ImagesListCell {
    private func setView() {
        contentView.addSubview(mainImageView)
        mainImageView.backgroundColor = .ypWhite50
        mainImageView.contentMode = .center
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        contentView.addSubview(likeButton)
        likeButton.setTitle("", for: .normal)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42)
        ])
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -8),
        ])
        
    }
}
