import Foundation

// MARK: - Extension HTTP Request

extension URLRequest {
    
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Получена ошибка запроса: \(NetworkError.urlRequestError(error))")
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    print("Получена ошибка сессии: \(NetworkError.urlSessionError)")
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                print(decodedData)
                fulfillCompletion(.success(decodedData))
            } catch {
                print("Получена ошибка декодирования: \(error.localizedDescription)")
                fulfillCompletion(.failure(error))
            }
        })
        task.resume()
        return task
    }
}
