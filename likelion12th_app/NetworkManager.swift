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

    let baseUrl: String = "http://localhost:8080"
    
    // 기본 POST 요청 메서드
    func postRequest<T: Codable>(to endpoint: String, bodyName: String, body: T? = nil, imageData: Data? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 멀티파트 설정
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        
        var requestBody = Data()
        
        // JSON 데이터 추가
        if let body = body {
            do {
                let jsonData = try JSONEncoder().encode(body)
                requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                requestBody.append("Content-Disposition: form-data; name=\"\(bodyName)\"\r\n".data(using: .utf8)!)
                requestBody.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
                requestBody.append(jsonData)
                requestBody.append("\r\n".data(using: .utf8)!)
            } catch {
                completion(.failure(error))
                return
            }
        }

        // 이미지 데이터 추가 (옵션)
        if let imageData = imageData {
            requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            requestBody.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            requestBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            requestBody.append(imageData)
            requestBody.append("\r\n".data(using: .utf8)!)
        }

        // 멀티파트 종료
        requestBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = requestBody
        
        // 네트워크 요청
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let serverError = NSError(domain: "Server Error", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
                completion(.failure(serverError))
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

    // 메시지 전송 메서드
    func postMessageData(to endpoint: String, sender: String, receiver: String, content: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let messageData = MessageRequest(sender: sender, receiver: receiver, contents: content)
        postRequest(to: endpoint, bodyName: "messageData", body: messageData, completion: completion)
    }

    // 회원 데이터 전송 메서드 (이미지 포함)
    func postMemberData(to endpoint: String, name: String, status: String, imageData: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        let memberData = MemberData(name: name, status: status)
        
        postRequest(to: endpoint, bodyName: "memberData", body: memberData, imageData: imageData, completion: completion)
    }
    
    // GET: 받은 메시지 가져오기
    func fetchReceivedMessages(for receiverName: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let endpoint = "/receivedMessages?receiverName=\(receiverName)"
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let messages = try decoder.decode([Message].self, from: data)  // [Message] 배열로 디코딩
                completion(.success(messages))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
