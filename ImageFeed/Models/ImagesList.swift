import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: PhotoURLs
}

struct PhotoURLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

struct PhotoLikeResult: Decodable {
    let photo: PhotoResult
}

//
//{
//  "photo": {
//    "id": "LF8gK8-HGSg",
//    "width": 5245,
//    "height": 3497,
//    "color": "#60544D",
//    "blur_hash": "LED+e[?GI8-PITbwkD$#0M-Tof9b",
//    "likes": 10,
//    "liked_by_user": true,
//    "description": "A man drinking a coffee.",
//    "urls": {
//      "raw": "https://images.unsplash.com/1/type-away.jpg",
//      "full": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg",
//      "regular": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=1080&fit=max",
//      "small": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=400&fit=max",
//      "thumb": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=200&fit=max"
//    },
//    "links": {
//      "self": "http://api.unsplash.com/photos/LF8gK8-HGSg",
//      "html": "http://unsplash.com/photos/LF8gK8-HGSg",
//      "download": "http://unsplash.com/photos/LF8gK8-HGSg/download"
//    }
//  },
//  "user": {
//    "id": "8VpB0GYJMZQ",
//    "username": "williamnot",
//    "name": "Thomas R.",
//    "links": {
//      "self": "http://api.unsplash.com/users/williamnot",
//      "html": "http://api.unsplash.com/williamnot",
//      "photos": "http://api.unsplash.com/users/williamnot/photos",
//      "likes": "http://api.unsplash.com/users/williamnot/likes"
//    }
//  }
//}
