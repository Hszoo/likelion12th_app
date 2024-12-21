//
//  MessageDetailViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/21/24.
//

import UIKit


class MessageDetailViewController: UIViewController {
    
    @IBOutlet var lblSender: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblContent: UILabel!
    
    var message: Message? // 메시지 데이터를 받을 변수
    var detailMessage: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSender.text = message?.sender
        // 이미지 URL 처리 (로컬 이미지 예시)
//        if let imgUrl = message?.imgUrl, let image = UIImage(named: imgUrl) {
//            imgView.image = image
//        } else {
//            // 기본 이미지 설정
//            imgView.image = UIImage(named: "defaultImage")  // 기본 이미지 이름
//        }
        lblContent.text = detailMessage?.contents // 전달받은 메시지 설정
        lblSender.text = detailMessage?.sender

    }
    
    func showDetailMessage(_ item: Message) {
        detailMessage = item
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil) // 닫기 버튼 액션
    }
}

