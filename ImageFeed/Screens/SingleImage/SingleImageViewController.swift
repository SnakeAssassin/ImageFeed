import UIKit
import Kingfisher

protocol SingleImageViewControllerDelegate: AnyObject {
    
    func dismissSingleImageViewControllerDelegate(_ vc: SingleImageViewController)
}

// MARK: - SingleImageViewController

final class SingleImageViewController: UIViewController {
    
    // MARK: Public Properties
    
    weak var delegate: SingleImageViewControllerDelegate?
    
    internal var imageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - Private Properties
    
    private var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image ?? UIImage(named: "Stub_cell"))
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "backToImagesList"
        button.setImage(UIImage(named: "Backward_white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(Self.didTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(Self.didShareButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        scrollView.delegate = self
    }
    
    // MARK: Actions
    
    @objc private func didShareButton(_ sender: UIButton) {
        shareContent(imageToShare: imageView)
    }
    
    @objc private func didTapButton() {
        delegate?.dismissSingleImageViewControllerDelegate(self)
    }
    

}

// MARK: - Private methods

private extension SingleImageViewController {
    
    private func loadImage() {
        UIBlockingProgressHUD.show()
        
        guard let fullImageURL = URL(string: imageURL!) else { return }
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                self.showError()
                print(error)
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Попробовать ещё раз?",
                                      preferredStyle: .alert)
        let alertActionNo = UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        alert.addAction(alertActionNo)
        let alertActionYes = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.loadImage()
        }
        alert.addAction(alertActionYes)
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard let imageSize = image?.size else { return }
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func shareContent(imageToShare: UIImageView) {
        guard let imageToShare = imageToShare.image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Create View

extension SingleImageViewController {
    private func setView() {
        
        view.backgroundColor = .ypBlack
        
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
        
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
