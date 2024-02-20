import UIKit

let AccessKey = "s2nqSSr7MH5OLFXmk9H4F0AIcbCY15EQRhlb81HfHgs"
let SecretKey = "REVovtK-XQ1t2mG1hJ4FYz5PnXnHURPW2fxDtXWedhg"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let BaseURL = URL(string: "https://unsplash.com")!
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

/*
Рекомендую вынести в enum и обращаться через static let:

  enum Constants {
 let AccessKey = "s2nqSSr7MH5OLFXmk9H4F0AIcbCY15EQRhlb81HfHgs"
 let SecretKey = "REVovtK-XQ1t2mG1hJ4FYz5PnXnHURPW2fxDtXWedhg"
 let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
 let AccessScope = "public+read_user+write_likes"

 let BaseURL = URL(string: "https://unsplash.com")!
 let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
 let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
       ...
  }
*/

