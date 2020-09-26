//
//  ViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//


import UIKit

class BasicSignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    // Properties
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkPasswordTextField: UITextField!
    @IBOutlet private weak var contentsTextView: UITextView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contentsTextView.delegate = self
        
        // imageView 제스처 추가
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView(gestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
    
        // 텍스트필드 딜리게이트로 해당 이벤트 실행이 안되어 addTarget 으로 구현
        nextButton.isEnabled = false
        idTextField.addTarget(self, action: #selector(objectsIsNotEmpty), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(objectsIsNotEmpty), for: .editingChanged)
        checkPasswordTextField.addTarget(self, action: #selector(objectsIsNotEmpty), for: .editingChanged)
    }
    
    // 화면 터치시 키보드 내려가게 하는 소스
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.checkPasswordTextField.resignFirstResponder()
        self.contentsTextView.resignFirstResponder()
    }

    // 이미지뷰에 이미지픽커 설정해주는 소스
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    // imageView 에 제스쳐 이벤트가 발생했을 때 작동하는 objc 함수
    @objc func tapView(gestureRecognizer: UIGestureRecognizer) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    // textField addTarget objc 함수
    @objc func objectsIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        if self.isValidCheckButton() {
            nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    // 모달 취소버튼 소스
    @IBAction func touchCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // imagePicker Delegate 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = originalImage

            self.nextButton.isEnabled = self.isValidCheckButton() ? true : false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // textView Delegate 함수
    func textViewDidChange(_ textView: UITextView) {
        if self.isValidCheckButton() {
            nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    // nextButton 액션함수
    @IBAction func nextButtonAction(_ sender: UIButton) {
        UserInformation.shared.id = idTextField.text
        UserInformation.shared.password = passwordTextField.text
    }
    
    // 이미지, 텍스트필드, 텍스트뷰 상태 검증 함수
    private func isValidCheckButton() -> Bool {
        guard
            let id = idTextField.text, !id.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let checkpassword = checkPasswordTextField.text, password == checkpassword,
            let textfield = contentsTextView.text, !textfield.isEmpty,
            self.imageView.image != nil
            else {
                return false
        }
        return true
    }
}
