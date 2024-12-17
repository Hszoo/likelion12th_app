//
//  JoinViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit

struct UserData: Codable { // 사용자 정보 data
    let name: String
    let status: String
}

class JoinViewController: UIViewController {
    
    @IBOutlet var selectStatus: UISegmentedControl! // 운영진, 아기사자 선택
    @IBOutlet var nameField: UITextField! // 이름
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnStart(_ sender: UIButton) {
        // 사용자 입력 값 가져오기
                guard let name = nameField.text, !name.isEmpty else {
                    print("이름을 입력하세요.")
                    return
                }

                let status = selectStatus.selectedSegmentIndex == 0 ? "BABYLION" : "ADULTLION"

                // API URL
                let apiURL = "/members/new"

                // 전송할 데이터 생성
                let userData = UserData(name: name, status: status)

                // POST 요청 전송
                NetworkManager.shared.postMemberData(to: apiURL, body: userData) { result in
                    switch result {
                    case .success(let data):
                        print("POST 성공: \(String(data: data, encoding: .utf8) ?? "응답 없음")")
                    case .failure(let error):
                        print("POST 실패: \(error.localizedDescription)")
                    }
                }
        do {
            let jsonData = try JSONEncoder().encode(userData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("전송 데이터 JSON: \(jsonString)")
            }
        } catch {
            print("JSON 인코딩 실패: \(error.localizedDescription)")
        }
    }

    
}
