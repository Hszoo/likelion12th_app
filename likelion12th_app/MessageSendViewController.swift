//
//  MessageSendViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit


class MessageSendViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var content: UITextView!
    @IBOutlet var receiver: UITextField!
    @IBOutlet var contentImg: UIImageView!
    
    var ornaments = [Ornament]()
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
        
        guard let image = contentImg.image else {
            showAlert(message: "이미지를 선택해주세요.")
            return
        }
        
        let newOrnament = Ornament(image: image, text: contentText)
        ornaments.append(newOrnament)
        
        
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
        _ = navigationController?.popViewController(animated: true)
        
    }

    /* 메시지 트리로 전송 */
    @IBAction func btnSendAll(_ sender: UIButton) {
        sendMessage(to: "all")
        guard let treeVC = storyboard?.instantiateViewController(withIdentifier: "TreeViewController") as? TreeViewController else { return }
                treeVC.ornaments = ornaments
                navigationController?.pushViewController(treeVC, animated: true)
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
