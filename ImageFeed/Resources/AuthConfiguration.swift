import UIKit

enum Constants {
    static let AccessKey = "s2nqSSr7MH5OLFXmk9H4F0AIcbCY15EQRhlb81HfHgs"
    static let SecretKey = "REVovtK-XQ1t2mG1hJ4FYz5PnXnHURPW2fxDtXWedhg"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    
    static let BaseURL = URL(string: "https://unsplash.com")!
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.AccessKey,
                                 secretKey: Constants.SecretKey,
                                 redirectURI: Constants.RedirectURI,
                                 accessScope: Constants.AccessScope,
                                 authURLString: Constants.UnsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.BaseURL)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         authURLString: String,
         defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
