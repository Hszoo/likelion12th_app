//
//  MemberViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet var userName: UILabel!
    
    var name: String? = UserManager.shared.userName
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userName.text = name
    }
}
