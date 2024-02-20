import Foundation

struct OAuthTokenResult: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
