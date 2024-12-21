//
//  CameraViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation

// 메시지 요청 구조체
struct MessageRequest: Codable {
    let sender: String
    let receiver: String
    let contents: String
}

class CameraViewController: UIViewController,
    UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    let placeholderText = "내용을 입력하세요."
    
    var ornaments = [Ornament]()
    let senderName = UserManager.shared.userName
    let endPoint: String = "/message/new"
    
    @IBOutlet var treeImg: UIImageView!
    @IBOutlet var treeContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 텍스트 뷰 초기화
        treeContent.text = placeholderText
        treeContent.textColor = .lightGray
        treeContent.delegate = self

        // 키보드 hide
        hideKeyboard()
        
        // 카메라 권한 확인
        AVCaptureDevice.requestAccess(for: .video) { (result) in
            print("카메라 접근 권한 : ", result)
        }
    }

    /* 카메라 실행*/
    @IBAction func btnCamera(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true
                
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [UTType.image.identifier]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    /* 트리로 사진 전송 */
    @IBAction func btnAddToTree(_ sender: UIButton) {
        sendMessage(to: "all")
        
        guard let treeVC = storyboard?.instantiateViewController(withIdentifier: "TreeViewController") as? TreeViewController else { return }
                treeVC.ornaments = ornaments
                navigationController?.pushViewController(treeVC, animated: true)
        
        // 직전 view 이동
        _ = navigationController?.popViewController(animated: true)
    }
    
    /* 메시지 전송 */
    private func sendMessage(to receiverName: String) {
        guard let contentText = treeContent.text, !contentText.isEmpty else {
            showAlert(message: "메시지 내용을 입력해주세요.")
            return
        }
        
        guard let image = treeImg.image else {
            showAlert(message: "이미지를 선택해주세요.")
            return
        }
        
        let newOrnament = Ornament(image: image, text: contentText)
        ornaments.append(newOrnament)
        
        NetworkManager.shared.postMessageData(to: endPoint, sender: senderName!, receiver: receiverName, content: contentText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let responseMessage = String(data: data, encoding: .utf8) ?? "응답 없음"
                    self.showAlert(message: "전송 성공: \(responseMessage)")
                case .failure(let error):
                    self.showAlert(message: "전송 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 경고 표시
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            print("TextView is empty")
        }
    }
    
    // delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let mediaType = info[.mediaType] as? String else {
            self.dismiss(animated: true, completion: nil)
            return
        }
            
        if mediaType == UTType.image.identifier {
            if let originalImage = info[.originalImage] as? UIImage {
                captureImage = originalImage
                    
                if flagImageSave {
                    UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
                }
                    
                treeImg.image = captureImage
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // UITextViewDelegate: 사용자 입력 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = "" // Placeholder 제거
            textView.textColor = .white // 일반 텍스트 색상
        }
    }
    
    // UITextViewDelegate: 사용자 입력 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText // Placeholder 복구
            textView.textColor = .lightGray
        }
    }
}
