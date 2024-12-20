//
//  UIViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/20/24.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboard() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,action: #selector(UIViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
