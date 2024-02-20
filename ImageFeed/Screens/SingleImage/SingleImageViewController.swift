import UIKit

// MARK: - SingleImageViewController

final class SingleImageViewController: UIViewController {
    
    // MARK: IB Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK:  IB Actions
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        shareContent(imageToShare: imageView)
    }
    
    // MARK: Private properties
    
    private var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Public methods

extension SingleImageViewController {
    
    func setImage(image: UIImage?) {
        self.image = image
    }
}

// MARK: - Private methods

private extension SingleImageViewController {
    
    func configure() {
        imageView.image = image
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage?) {
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
    
    func shareContent(imageToShare: UIImageView) {
        guard let imageToShare = imageToShare.image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}


