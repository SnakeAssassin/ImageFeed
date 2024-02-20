import Foundation

// MARK: - Extension HTTP Session
//
//extension URLSession {
//    
//    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
//        
//        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        
//        let task = dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    fulfillCompletion(.success(data))
//                } else {
//                    print("Получен ответ Status Code >300:")
//                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
//                }
//                
//                
//                
//            } else if let error = error {
//                print("Получена ошибка запроса: \(NetworkError.urlRequestError(error))")
//                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
//            } else {
//                print("Получена ошибка сессии: \(NetworkError.urlSessionError)")
//                fulfillCompletion(.failure(NetworkError.urlSessionError))
//            }
//        })
//        task.resume()
//        return task
//    }
//}
