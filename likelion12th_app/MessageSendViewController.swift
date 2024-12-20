//
//  MessageSendViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit

// 메시지 요청 구조체
struct MessageRequest: Codable {
    let sender: String
    let receiver: String
    let contents: String
}

class MessageSendViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var content: UITextView!
    @IBOutlet var receiver: UITextField!
    
    let senderName = "sj"
    let endPoint: String = "/message/new"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()

        // Delegate 설정
        receiver.delegate = self
        content.delegate = self
    }
    
    private func sendMessage(to receiverName: String) {
        guard let contentText = content.text, !contentText.isEmpty else {
            showAlert(message: "메시지 내용을 입력해주세요.")
            return
        }
        
        guard let receiverName = receiver.text, !receiverName.isEmpty else {
            showAlert(message: "수신자를 입력해주세요.")
            return
        }
        
        NetworkManager.shared.postMessageData(to: endPoint, sender: senderName, receiver: receiverName, content: contentText) { result in
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
    
    /* 메시지 전송 */
    @IBAction func btnSendMessage(_ sender: UIButton) {
        guard let receiverText = receiver.text, !receiverText.isEmpty else {
            showAlert(message: "수신자를 입력해주세요.")
            return
        }
            
        sendMessage(to: receiverText)
    }

    /* 메시지 전체 전송 */
    @IBAction func btnSendAll(_ sender: UIButton) {
        sendMessage(to: "all")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // delegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("TextView editing started")
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField editing started")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            print("TextView is empty")
        }
    }
}
