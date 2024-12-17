//
//  NetworkManager.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    let baseUrl : String = "http://localhost:8080"
    
    func postMemberData<T: Codable>(to endpoint: String, body: T, completion: @escaping (Result<Data, Error>) -> Void) {
            guard let url = URL(string: baseUrl + endpoint) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                    return
                }

                completion(.success(data))
            }
            task.resume()
        }
    
    func postRequest<T: Codable>(to endpoint: String, body: T, completion: @escaping(Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseUrl + endpoint) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 인코딩
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러 처리
            if let error = error {
            completion(.failure(error))
            return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let serverError = NSError(domain: "Server Error", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
                completion(.failure(serverError))
            return
            }

            // 데이터 반환
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -3, userInfo: nil)))
                return
            }
                
            completion(.success(data))
        }
        task.resume()
    }
    
}
