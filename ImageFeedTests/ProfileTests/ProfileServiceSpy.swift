import ImageFeed
import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {
        profile = Profile(username: "", name: "", loginName: "", bio: "")
    }
}
