import Foundation

struct ProfileResult: Decodable {
    var username: String?
    var firstName: String?
    var lastName: String?
    var bio: String?
}

struct UserResult: Decodable {
    let profileImage: [String: String]?
}
