//
//  JoinViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit

struct MemberData: Codable { // 사용자 정보 data
    let name: String 
    let status: String
}

class JoinViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var selectStatus: UISegmentedControl! // 운영진, 아기사자 선택
    @IBOutlet var nameField: UITextField! // 이름
    @IBOutlet var profileImgView: UIImageView! // 프로필 사진
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* 프로필 사진 선택 */
    @IBAction func selectProfileImg(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // 사진 라이브러리에서 사진을 선택하도록 설정
        imagePickerController.allowsEditing = true // 편집 가능
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 이미지 선택 후 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImgView.image = selectedImage // 이미지뷰에 선택한 사진을 설정
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnStart(_ sender: UIButton) {
        // 사용자 입력 값 가져오기
        guard let name = nameField.text, !name.isEmpty else {
            print("이름을 입력하세요.")
            return
        }

        let status = selectStatus.selectedSegmentIndex == 0 ? "BABYLION" : "ADULTLION"

        // API URL
        let endPoint = "/members/new"
        
        // 프로필 사진을 JPEG 데이터로 변환
        guard let profileImage = profileImgView.image, let imageData = profileImage.jpegData(compressionQuality: 0.8) else {
            print("프로필 사진을 선택하세요.")
            return
        }

        // 전송할 데이터 생성
        let memberData = MemberData(name: name, status: status)

        // POST 요청 전송
        NetworkManager.shared.postMemberData(to: endPoint, name:name, status: status, imageData: imageData) { result in
            switch result {
            case .success(let data):
                print("POST 성공: \(String(data: data, encoding: .utf8) ?? "응답 없음")")
                DispatchQueue.main.async {
                    // 성공 후 UI 업데이트 (예: 화면 전환)
                }
            case .failure(let error):
                print("POST 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    // 실패 시 UI 업데이트 (예: 오류 메시지 표시)
                }
            }
        }
        
        do {
            let jsonData = try JSONEncoder().encode(memberData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("전송 데이터 JSON: \(jsonString)")
            }
        } catch {
            print("JSON 인코딩 실패: \(error.localizedDescription)")
        }
    }
}
