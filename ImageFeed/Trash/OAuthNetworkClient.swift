//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Joe Kramer on 25.01.2024.
//
/*
import Foundation

//  Протокол для обращения 
protocol OAuthNetworkClientProtocol {
    func makeRequest(code: String, httpMethod: String) -> URLRequest
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask
}


// MARK: Network Connection
class OAuthNetworkClient: OAuthNetworkClientProtocol {
    
    /// Обработка ошибок
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    
    /// 1. Создаем запрос (URL, httpMethod)
    func makeRequest(code: String, httpMethod: String) -> URLRequest {
        /// Создаем URL для URLRequest
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        
        /// Формируем запрос URLRequest с глаголом POST
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
    
    /// 2. Создаем задачу URLSession на отправление запроса request в сеть
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        /// После вызова задачи отправки запроса и получения ответа, необходимо вернуться в главный поток
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            /// Гарантированно «возвращаем» данные через блок на главном потоке
            DispatchQueue.main.async {
                completion(result)
            }
        }
        /// Создаем задачу URLSession на отправление запроса request в сеть
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse
            {
                /// 1. Обработка данных, при коде ответа 2xx-3xx
                if 200..<300 ~= response.statusCode {
                    fulfillCompletion(.success(data))
                    
                    /// 2. Обработка кода ответа 4xx-5xx
                } else {
                    /// Передаем код ошибки
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                }
                
                
                /// 4. Обработка ошибки уровня URLSession (потеря соединения, таймаут и т.д.)
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                
                /// 5. Обработка теоретической ошибки нарушения контракта URLSession
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        /// Выполнение сетевого запроса с использованием URLSession.shared
        task.resume()
        /// Возвращаем URLSessionTask (данные или ошибку)
        return task
    }
}

*/
