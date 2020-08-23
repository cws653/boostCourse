//
//  SecondViewController.swift
//  SignUp_v1
//
//  Created by 최원석 on 2020/07/23.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView(gestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
        
//        setupAppTargetIsNotEmpyTextFields()
        
    }
    
    
    // 모달 취소버튼 소스
    @IBAction func touchCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 이미지뷰에 이미지픽커 설정해주는 소스
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @objc func tapView(gestureRecognizer: UIGestureRecognizer) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = originalImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // 조건에 따라 버튼 비활성화 소스
    @IBOutlet weak var touchNextButton: UIButton!
    @IBOutlet weak var touchIDTextField: UITextField!
    @IBOutlet weak var touchPasswordField: UITextField!
    @IBOutlet weak var touchCheckPasswordField: UITextField!
    @IBOutlet weak var touchTextView: UITextView!
    
    
    func setupAppTargetIsNotEmpyTextFields() {
        touchNextButton.isEnabled = false
        touchIDTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        touchPasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        touchCheckPasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let id = touchIDTextField.text, !id.isEmpty,
            let password = touchPasswordField.text, !password.isEmpty,
            let checkpassword = touchCheckPasswordField.text, password == checkpassword,
            let textfield = touchTextView.text, !textfield.isEmpty
            else
        {
            self.touchNextButton.isEnabled = false
            return
        }
        // enable okButton if all conditions are met
        touchNextButton.isEnabled = true
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
