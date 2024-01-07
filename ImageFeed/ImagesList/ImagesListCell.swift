import UIKit

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
}



    // MARK: - Public methods

extension ImagesListCell {
    
    func configCell(with imageName: String, isLiked: Bool) {
        if let image = UIImage(named: imageName) {
            mainImageView.image = image
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
        let imageName = isLiked ? "Active" : "No Active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
