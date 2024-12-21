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
    var ornaments = [Ornament]() {
        didSet {
            setupTree()
        }
    }
    
    var treeWidth: CGFloat = 0
    var treeHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면 크기를 기준으로 트리 크기 계산
        treeWidth = UIScreen.main.bounds.width * 1
        treeHeight = UIScreen.main.bounds.height * 0.8
        
        drawTriangleBoundary()
        setupTree()
        print("TreeViewController ornaments:", ornaments) // 디버깅
    }

    @objc func showMessage(sender: UIButton) {
        let ornament = ornaments[sender.tag] // 클릭된 버튼의 태그를 통해 오너먼트 데이터 참조
        let alert = UIAlertController(title: "입력한 메시지", message: ornament.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func setupTree() {
        for (index, ornament) in ornaments.enumerated() {
            let ornamentButton = UIButton(frame: randomPositionInTreeTriangle())
            ornamentButton.setImage(ornament.image, for: .normal)
            ornamentButton.tag = index // 버튼 태그로 오너먼트 인덱스 설정
            ornamentButton.imageView?.contentMode = .scaleAspectFit
            ornamentButton.addTarget(self, action: #selector(showMessage), for: .touchUpInside)
            view.addSubview(ornamentButton) // 트리 추가
            
            UIView.animate(withDuration: 0.5, animations: {
                ornamentButton.alpha = 1.0
                ornamentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.3) {
                    ornamentButton.transform = .identity
                }
            }
        }
    }
    
    // 버튼의 랜덤 위치 계산 (화면 크기 기반)
    func randomPositionInTreeTriangle() -> CGRect {
        let x1 = treeWidth / 2, y1: CGFloat = 150 // 트리 꼭대기
        let x2: CGFloat = 0, y2 = treeHeight // 트리 좌하단
        let x3 = treeWidth, y3 = treeHeight // 트리 우하단

        // 랜덤 가중치 생성
        let r1 = Double.random(in: 0...1)
        let r2 = Double.random(in: 0...(1 - r1))
        let r3 = 1 - r1 - r2

        // 삼각형 내부 좌표 계산
        let randomX = CGFloat(Double(x1) * r1 + Double(x2) * r2 + Double(x3) * r3)
        let randomY = CGFloat(Double(y1) * r1 + Double(y2) * r2 + Double(y3) * r3)

        let buttonWidth: CGFloat = 240  // 버튼 너비
        let buttonHeight: CGFloat = 240  // 버튼 높이

        // 버튼 크기만큼 여유 공간을 트리 영역 내에 두기 위해 위치 제한
        let xLimit = treeWidth - buttonWidth
        let yLimit = treeHeight - buttonHeight

        // 랜덤 위치가 트리 범위 내에 있도록 수정
        let finalX = min(max(randomX, 0), xLimit)
        let finalY = min(max(randomY, 150), yLimit)

        return CGRect(x: finalX, y: finalY, width: buttonWidth, height: buttonHeight)
    }
    
    // 트리 경계를 그리는 함수
    func drawTriangleBoundary() {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: treeWidth / 2, y: 150))
        trianglePath.addLine(to: CGPoint(x: 0, y: treeHeight))
        trianglePath.addLine(to: CGPoint(x: treeWidth, y: treeHeight))
        trianglePath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = trianglePath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
    }
}
