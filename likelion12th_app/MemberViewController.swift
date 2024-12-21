//
//  MemberViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userName.text = UserManager.shared.userName
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
    */

}
