import Foundation

// Вынести!

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



    
    /// decodingType: Метатип типа T, который указывает на тип данных, который вы хотите получить после декодирования ответа.
    /// Result<T, Error>, где T - это тип данных после декодирования, а Error - тип ошибки, если запрос не удался.
    /// <T: Decodable> указывает, что тип T должен соответствовать протоколу Decodable, который является протоколом Swift для типов, которые могут быть декодированы из JSON-представления. То есть, T может быть любым типом данных, который может быть декодирован из JSON, таким как структуры или классы, которые соответствуют протоколу Decodable.
    
    /// Использование обобщенного параметра <T: Decodable> позволяет этой функции быть универсальной и принимать любой тип данных, который можно декодировать из JSON.
extension URLSession {
    func data<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, let response = response else {
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
                print("3")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                print(decodedData)
                fulfillCompletion(.success(decodedData))
                print("4")
            } catch {
                print("Получена ошибка декодирования: \(error.localizedDescription)")
                fulfillCompletion(.failure(error))
                print("5")
            }
        })
        task.resume()
        return task
    }
}
