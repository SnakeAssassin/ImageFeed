//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Joe Kramer on 14.12.2023.
//

import UIKit

extension ImagesListViewController: UITableViewDataSource {
    // Количество секций
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество ячеек у секций
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    // Обработка нажатий на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

final class ImagesListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

