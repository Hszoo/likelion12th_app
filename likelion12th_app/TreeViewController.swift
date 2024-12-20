//
//  TreeViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/21/24.
//

import UIKit

struct Ornament {
    var image: UIImage
    var text: String
}

class TreeViewController: UIViewController {
    var ornaments = [Ornament]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTree()
    }

    func setupTree() {
        for (index, ornament) in ornaments.enumerated() {
            let ornamentButton = UIButton(frame: randomPositionOnTree()) // 랜덤 위치 지정
            ornamentButton.setImage(ornament.image, for: .normal)
            ornamentButton.tag = index // 버튼 태그로 오너먼트 인덱스 설정
            ornamentButton.addTarget(self, action: #selector(showMessage), for: .touchUpInside)
            view.addSubview(ornamentButton) // 화면에 추가
            
            UIView.animate(withDuration: 0.3) { // 애니메이션 추가
                ornamentButton.alpha = 1.0
            }
        }
    }

    
    @objc func showMessage(sender: UIButton) {
        let ornament = ornaments[sender.tag] // 클릭된 버튼의 태그를 통해 오너먼트 데이터 참조
        let alert = UIAlertController(title: "입력한 메시지", message: ornament.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // 버튼의 랜덤 위치 계산
    func randomPositionOnTree() -> CGRect {
        let x = Int.random(in: 50...250) // x축 범위 (트리 영역 내)
        let y = Int.random(in: 100...400) // y축 범위
        return CGRect(x: x, y: y, width: 50, height: 50) // 버튼 크기 50x50
    }
    
}
