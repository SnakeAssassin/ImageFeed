import Foundation
/*

final class MyClass {
    
    // Получаем Bearer-токен
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ){
        
        // 2. Формирование HTTP-запроса (POST) через метод 2.1 authTokenRequest -> URLRequest
        let request = authTokenRequest(code: code)
        
        // 3. Отправка асинхронного HTTP-запроса и обработка ответа (в замыкании вернется OAuthTokenResponseBody
        let task = object(for: request) { /*[weak self]*/ result in
            /*guard let self = self else {
             print("result or error")
             return
             }*/
            
            
            switch result {
                // Если запрос успешен, то извлекается токен доступа и сохраняется в authToken, который пишется в UserDefaults
            case .success(let body):
                print("print struct")
                print(body.accessToken)
                print(body.tokenType)
                print(body.scope)
                print(body.createdAt)
                
                
                let authToken = body.accessToken
                print("ok")
                print(authToken)
                
                self.authToken = authToken
                // Вызывается completion с успешным результатом ???
                completion(.success(authToken))
                // Если запрос неуспешен, то через completion передается ошибка для последующей обработки
            case .failure(let error):
                completion(.failure(error))
                print("error")
                print(error)
            }
        }
        // Запуск асинхронной задачи, представленной объектом URLSessionTask, который был возвращен из метода object(for:completion:).
        task.resume()
        print("Значение в UserDefaults: \(UserDefaults.standard.object(forKey: "OAuth2TokenKey") as Any)")
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        // 2.1.1 Вызываем из расширения метод для формирования URL и глагола и передаем URLRequest
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        // 2.1.2 Создание HTTP-запроса с заданным URL
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        
        // 2.1.3 Изменение HTTP-глагола
        request.httpMethod = httpMethod
        return request
    }
    
}
class Testf {
    
    struct JSONResponse: Decodable {
      var access_token: String
      var token_type: String
      var scope: String
      var created_at: Int
    }
    
    func getRequest(code: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        // Создаем URL для URLRequest
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        
        // Формируем запрос URLRequest с глаголом POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // // Создаем задачу URLSession на отправление запроса request в сеть
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //DispatchQueue.main.async {
            
            //}
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return  // Если ошибка - завершаем код
            }
            
            if let response = response as? HTTPURLResponse {
                if 200 ..< 300 ~= response.statusCode {
                    print("Error: \(response.statusCode)")
                }
                
                guard let data = data else { return }
                
                
                do {
                    // используем метод `JSONSerialization.decode(...`, который возвращает структуру данных
                    // Метод автоматически раскладывает полученные данные в структуру в тип String (!)
                    let json = try JSONDecoder().decode(JSONResponse(), from: data)
                    
                } catch {
                    print("Failed to parse: \(error.localizedDescription)")
                }
                
                completion(.success(data))
                
                
                
                task.resume()
            }
        }
    }
}

 
 
func fetchOAuthToken(code: String, completion: @escaping (Result<Data, Error>) -> Void ) {
    
    Запрашиваем Bearer-токен
    // 1. Формируем запрос:
    let request = makeURLRequest(code: code)
    
    func makeURLRequest(code: String) -> URLRequest {
        // Создаем HTTP-запрос и глагол POST
    }
 
    // 2. Отправляем запрос:
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
    
 
 
 }
 
 
 
 
*/



