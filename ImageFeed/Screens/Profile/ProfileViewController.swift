import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: Private properties
    
    private let profileService = ProfileService.shared
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "Photo")
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true

        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = /*ProfileService.shared.profile?.name ??*/ "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = /*ProfileService.shared.profile?.loginName ??*/ "@ekaterina_now"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = /*ProfileService.shared.profile?.bio ??*/ "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Exit"), for: .normal)
        
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(Self.didTapButton), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: Actions
    
    @objc func didTapButton() {
        OAuth2TokenStorage.shared.removeToken()
        print("Токен удален")
    }
    
//    // MARK: I. Observer через селектор
//    
//    /// Вариация устаревшего API (до iOS 4)
//    /// Стабильное и надежное, относительного нового API.
//    /// При добавлении наблюдателя, нельзя отписываться больше, чем подписываться
//    
//    /// 1. Перегружаем конструктор
//    override init(nibName: String?, bundle: Bundle?) {
//        super.init(nibName: nibName, bundle: bundle)
//        addObserver()
//    }
//    
//    /// 2. Определяем конструктор для декодирования класса из Storyboard
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addObserver()
//    }
//    
//    /// 3. Определяем деструктор
//    deinit {
//        removeObserver()
//    }
//    
//    /// 4. Подписываем наблюдателя (центр уведомлений по умолчанию NotificationCenter.default)
//    private func addObserver() {                                // Вызывается из init
//        NotificationCenter.default.addObserver(                 // Добавляем наблюдателя в центр уведомлений
//            self,                                               // self - класс, который будет получать уведомления
//            selector: #selector(updateAvatar(notification:)),   // Селектор вызывается на self при опубликовании уведомления
//            name: ProfileImageService.DidChangeNotification,    // Имя уведомления (задано в ProfileImageService)
//            object: nil)                                        // nil для передачи уведомления от любых источников
//    }                                                           // или можно указать ProfileImageService.shared
//    
//    /// 5. Отписываем наблюдателя
//    private func removeObserver() {                             // Вызывается из deinit
//        NotificationCenter.default.removeObserver(              // Отписываем наблюдателя из центра уведомлений
//            self,                                               // Аргументы совпадают с подпиской
//            name: ProfileImageService.DidChangeNotification,    // Аргументы совпадают с подпиской
//            object: nil)                                        // Аргументы совпадают с подпиской
//    }
//
//    /// 6. Получаем нотификацию. В момент публикации нотификации, в этот метод будет переданы данные от нотификации
//    @objc                                                       // Аннотация objc, т.к. селектор создается только для Objc-C методов
//    private func updateAvatar(notification: Notification) {     // Селектор должен иметь аргумент типа Notification (в нем будет нотификация)
//        guard                                                   // До viewDidLoad аутлеты класса могут быть не проинициализированы,
//            isViewLoaded,                                       // поэтому если isViewLoaded == false, то покидаем функцию
//            let userInfo = notification.userInfo,               // Достаем данные из нотификации
//            let profileImageURL = userInfo["URL"] as? String,   // Достаем ссылку в виде String
//            let url = URL(string: profileImageURL)              // Преобразовываем String-ссылку в вид URL
//        else { return }
//        // TODO: [Sprint 11] Обновить аватар через Kingfisher
//    }
    
    // MARK: II. Observer через блоки
    
    /// 1. Объявляем проперти для хранения обсервера (нужен для управления жизненным циклом)
    private var profileImageServiceObserver: NSObjectProtocol?
                                                                
    /// 2. Создаем обсервер
    private func startObserver() {                              // Вызвать в ViewDidLoad
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification, // Имя уведомления
            object: nil,                                        // nil для получения уведомления от любых источников
            queue: .main) {                                     // Очередь, на которой будут приниматься уведомления,
                                                                // т.к. обновления UI возможно только из главной очереди
                [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                            // Вызываем метод обномлвения аватара по полученным данным
            }
         updateAvatar()                                      // Вызвать в ViewDidLoad
                                                                // Добавленный обсервер может получить нотификацию после момента добавления, и запрос на получение аватарки может успеть завершиться. Поэтому в ViewDidLoad пробуем обновить аватар
    }
    
    /// 3. Обновляем аватар
    /// Метод для обновления аватарки. Он почти совпадает с предыдущей версией, но теперь нет аннотации @objc, так как нам не нужен селектор и нет проверки на isViewLoaded из-за гарантии вызова updateAvatar либо из viewDidLoad, либо после, получив нотификацию.
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO: [Sprint 11] Обновить аватар через Kingfisher
        profileImageView.kf.indicatorType = .activity
        
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "Stub")) //{ result in
//            switch result {
//            
//            // Успех
//            case .success(let value):
//                // картинка
//                
//                print("value.image: ", value.image)
//                
//                // Откуда картинка загружена:
//                // - .none — из сети.
//                // - .memory — из кэша оперативной памяти.
//                // - .disk — из дискового кэша.
//                
//                print("value.cacheType: ", value.cacheType)
//                // Информация об источнике.
//                print("value.source: ", value.source)
//                
//            // Ошибка
//            case .failure(let error):
//                print("error: ", error)
//            }
//        }
    }
    
///    А когда произойдёт отписывание от нотификации removeObserver?
///    Когда объект ProfileViewController будет деаллоцирован, и вместе с этим будет уничтожена ссылка profileImageServiceObserver. Либо если мы занилим или присвоим другое значение в profileImageServiceObserver явным образом. В зависимости от имплементации, observer может прожить в iOS SDK какое-то время после обнуления значения profileImageServiceObserver, но это скорее баг, чем ожидаемое поведение. На такое рассчитывать не стоит.
///    Можно заметить, что  используя «новое» API, мы существенно упростили код приложения. По этой причине для всех версий, где оно доступно (iOS 4 и выше) желательно использовать именно его.
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        startObserver()                                         // Добавление обсервера
        updateAvatar()                                         // Обновление аватара для обсервера
    }
}


// MARK: - Create View

extension ProfileViewController {
    
    private func createView() {
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        setProfileImage()
        setNameLabel()
        setIdLabel()
        setDescriptionLabel()
        setExitButton()
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = ProfileService.shared.profile?.name
        idLabel.text = ProfileService.shared.profile?.loginName
        descriptionLabel.text = ProfileService.shared.profile?.bio
        
        //profileImageView.image = URL
        
    }
    
    private func setProfileImage() {
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setNameLabel() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setIdLabel() {
        view.addSubview(idLabel)
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }
    
    private func setDescriptionLabel() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setExitButton() {
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
    }
}
