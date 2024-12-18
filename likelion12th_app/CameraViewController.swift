//
//  CameraViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/18/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    
    
    
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        AVCaptureDevice.requestAccess(for: .video) { (result) in
            print("카메라 접근 권한 : ", result)
        }
        
//        let captureSession = AVCaptureSession()
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//            print("카메라를 찾을 수 없습니다.")
//            return
//        }
//        do {
//            let input = try AVCaptureDeviceInput(device: camera)
//            captureSession.addInput(input)
//        } catch {
//            print("카메라 입력을 추가하는 중 오류 발생: \(error.localizedDescription)")
//        }
    }
    

    /* 카메라 실행*/
    @IBAction func btnCamera(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true
                
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [UTType.image.identifier]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    
    /* 사진 꾸미기 */
    @IBAction func btnDecorate(_ sender: UIButton) {
    }

    
    /* 경고 표시 */
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    /* 델리게이트 메서드 */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let mediaType = info[.mediaType] as? String else {
            self.dismiss(animated: true, completion: nil)
            return
        }
            
        if mediaType == UTType.image.identifier {
            if let originalImage = info[.originalImage] as? UIImage {
                captureImage = originalImage
                    
                if flagImageSave {
                    UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
                }
                    
                imgView.image = captureImage
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
