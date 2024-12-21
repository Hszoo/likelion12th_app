//
//  MessageCell.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/21/24.
//

import UIKit

class MessageCell: UICollectionViewCell {

    @IBOutlet var msImage: UIImageView!
    @IBOutlet var msSender: UILabel!
    @IBOutlet var msContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // 메시지 데이터를 셀에 설정
    func configure(with message: Message) {
        msContent.text = message.contents
        msSender.text = "From: \(message.sender)"
        msImage.image = UIImage(named: message.sender)
    }
}
