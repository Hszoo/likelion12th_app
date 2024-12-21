//
//  MessageDetailViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/21/24.
//

import UIKit


class MessageDetailViewController: UIViewController {
    @IBOutlet weak var detailLabel: UILabel! // 메시지 상세 내용을 표시할 레이블
    
    var message: String? // 메시지 데이터를 받을 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = message // 전달받은 메시지 설정
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil) // 닫기 버튼 액션
    }
}
