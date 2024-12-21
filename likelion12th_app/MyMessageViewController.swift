//
//  MyMessageViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit

class MyMessageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!

    var isNewMsg: Bool = true
    
    let messages = ["메시지 1", "메시지 2", "메시지 3", "메시지 4"] // 예시 메시지 데이터

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
      
    // Collection View 데이터 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // 셀 생성 및 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
            fatalError("셀을 MessageCell로 캐스팅할 수 없습니다.")
        }
        cell.msContent.text = messages[indexPath.row] // 메시지 설정
        return cell
    }
    
    // 셀 선택 시 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMessage = messages[indexPath.row]
        presentMessageDetail(message: selectedMessage) // 상세 메시지 표시
    }
    
    func presentMessageDetail(message: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard 로드
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "MessageDetailViewController") as? MessageDetailViewController else {
            return
        }
        detailVC.message = message // 메시지 데이터 전달

        // Bottom Sheet 스타일 설정
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // 중간 및 큰 높이 설정
            sheet.prefersGrabberVisible = true // Grabber 표시
        }
        
        present(detailVC, animated: true, completion: nil) // 모달 표시
    }

}
