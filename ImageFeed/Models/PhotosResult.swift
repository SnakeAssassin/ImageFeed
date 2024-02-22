import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: PhotoURLs
}

struct PhotoURLs: Codable {
    let full: String
    let thumb: String
}
