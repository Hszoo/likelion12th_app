//  HomeViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/21/24.
//

import UIKit

class HomeViewController: UIViewController {

    // 이미지 배열
    let images: [UIImage] = [
        UIImage(named: "lion_1.jpg")!,
        UIImage(named: "lion_2.jpg")!,
        UIImage(named: "lion_3.jpg")!,
        UIImage(named: "lion_4.jpg")!,
        UIImage(named: "lion_5.jpg")!,
        UIImage(named: "lion_6.jpg")!
    ]
    
    var currentImageIndex = 1
    var imageChangeTimer: Timer?
    
    @IBOutlet var mainImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImg.image = images[0]
        startImageChangeTimer()
    }
    
    @IBAction func btnMainStart(_ sender: Any) {
    }
    
    // 타이머 시작
    func startImageChangeTimer() {
        imageChangeTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }

    // 타이머 정지
    func stopImageChangeTimer() {
        imageChangeTimer?.invalidate()
        imageChangeTimer = nil
    }
    
    // 이미지 변경 함수
    @objc func changeImage() {
        UIView.transition(with: mainImg, duration: 0.5, options:
                .transitionCrossDissolve, animations: {
            self.mainImg.image = self.images[self.currentImageIndex]
        })
        
        // 인덱스를 다음 이미지로 업데이트, 마지막 이미지를 넘으면 처음으로 돌아감
        currentImageIndex = (currentImageIndex + 1) % images.count
    }
}

