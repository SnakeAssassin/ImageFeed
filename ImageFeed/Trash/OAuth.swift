//
//  File2.swift
//  ImageFeed
//
//  Created by Joe Kramer on 25.01.2024.
//

import Foundation


/*


class OAuthService  {
    
    let networkClient: OAuthNetworkClientProtocol
   
    init(networkClient: OAuthNetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        
        var code = ""
        
        let request = networkClient.makeRequest(code: code, httpMethod: "POST")
        let response = networkClient.data(for: request) { result in
            /// Конструкция switch, которая проверяет значение result
            switch result {
            /// Если результат запроса успешен, то извлекается ассоциированное значение data из результ
            case .success(let data):
                /// Попытка декодировать данные data в структуру MostPopularMovies
                /// Если декодирование успешно, вызывается handler с результатом .success и распакованным объектом mostPopularMovies
                /// В случае ошибки вызывается handler с результатом .failure и передается сама ошибка
                do {
                    let token = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    print(error)
                }
            /// Из результата запроса failure извлекается ассоциированное значение error из result и вызывается handler с результатом .failure и передается ошибка
            case .failure(let error):
                print(error)
            }
            
            /*do {
                let json =  try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                self.authToken = json.accessToken
            } catch {
                print(error)
            }
            
            
            Result { try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
            }
        
        
            }*/
    }
    // 3.1.1 Структура для декодирования полученного ответа после POST-запроса
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
    
    
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
    }
    
    
}



    
    /// Вызов метода fetch (асинхронный запрос данных из сети)
    /// Используется замыкание, которое принимает result
    networkClient.fetch(url: mostPopularMoviesUrl) { result in
        /// Конструкция switch, которая проверяет значение result
        switch result {
        /// Если результат запроса успешен, то извлекается ассоциированное значение data из результ
        case .success(let data):
            /// Попытка декодировать данные data в структуру MostPopularMovies
            /// Если декодирование успешно, вызывается handler с результатом .success и распакованным объектом mostPopularMovies
            /// В случае ошибки вызывается handler с результатом .failure и передается сама ошибка
            do {
                let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                handler(.success(mostPopularMovies))
            } catch {
                handler(.failure(error))
            }
        /// Из результата запроса failure извлекается ассоциированное значение error из result и вызывается handler с результатом .failure и передается ошибка
        case .failure(let error):
            handler(.failure(error))
        }
    }
}

}

*/
