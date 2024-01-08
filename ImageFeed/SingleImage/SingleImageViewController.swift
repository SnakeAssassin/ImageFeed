import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }  // Проверяем было ли ранее загружено view, если view не загружено (т.е. аутлет не инициализирован) будет краш
            imageView.image = image // проставляем новое изображение, если мы сюда попадаем извне (не из сегвея, например по свайпу)
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Инициализация аутлета (для предотвращения краша из-за nil image) переданного image и передача его в UI при показе экрана
        imageView.image = image
    }
}
