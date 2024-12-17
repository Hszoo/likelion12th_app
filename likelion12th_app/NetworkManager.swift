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

    let url : String = "https://localhost:8080"
    
    func postMemberData<T: Codable>(to urlString: String, body: T, completion: @escaping (Result<Data, Error>) -> Void) {
            guard let url = URL(string: url + urlString) else {
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
}
