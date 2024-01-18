import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: Properties
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }  // Проверяем было ли ранее загружено view, если view не загружено (т.е. аутлет не инициализирован) будет краш
            imageView.image = image // проставляем новое изображение, если мы сюда попадаем извне (не из сегвея, например по свайпу)
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        shareContent(imageToShare: imageView)
    }
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Инициализация аутлета (для предотвращения краша из-за nil image) переданного image и передача его в UI при показе экрана
        imageView.image = image
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: Methods
    
    // Центровка и установки уровня зума
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        // Шаг 1: Получение минимального и максимального уровня зума из UIScrollView
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        // Шаг 2: Гарантия применения всех изменений в Layout
        view.layoutIfNeeded()

        // Шаг 3: Получение размеров видимой области UIScrollView и размеров изображения
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size

        // Шаг 4: Расчет масштабов по горизонтали и вертикали
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height

        // Шаг 5: Выбор максимального уровня зума
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))

        // Шаг 6: Установка уровня зума для UIScrollView
        scrollView.setZoomScale(scale, animated: false)

        // Шаг 7: Еще один вызов layoutIfNeeded() для гарантии применения изменений
        scrollView.layoutIfNeeded()

        // Шаг 8: Получение нового размера контента UIScrollView после установки уровня зума
        let newContentSize = scrollView.contentSize

        // Шаг 9: Вычисление координат x и y для центрирования контента и установка их в setContentOffset
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func shareContent(imageToShare: UIImageView) {
        // Проверяем, есть ли изображение в imageView
        guard let imageToShare = imageToShare.image else {
            return
        }
        // Создаем UIActivityViewController с изображением в качестве общего контента
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        // Показываем контроллер обмена
        present(activityViewController, animated: true, completion: nil)
    }
    
}

// MARK: - Extension Methods

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


