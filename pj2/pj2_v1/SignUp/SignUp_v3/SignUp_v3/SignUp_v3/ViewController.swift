//
//  ViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // 프로퍼티
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            if self.imageView.image != nil {
                    print("image is not nil")
            }
        }
    }
    
    @IBOutlet private weak var touchNextButton: UIButton!
    @IBOutlet private weak var touchIDTextField: UITextField!
    @IBOutlet private weak var touchPasswordField: UITextField!
    @IBOutlet private weak var touchCheckPasswordField: UITextField!
    @IBOutlet private weak var touchTextView: UITextView!
    
    // 10-200 룰
    // 함수는 10줄안에, 클래스는 200줄안에
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.touchTextView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView(gestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
        
        //        setupAppTargetIsNotEmpyTextFields()
        
        //텍스트필드, 텍스트뷰, 이미지뷰 조건을 연동해서 버튼 작용하게 하기
        touchNextButton.isEnabled = false
        
        touchIDTextField.addTarget(self, action: #selector(objectsIsNotEmpty_v1), for: .editingChanged)
        touchPasswordField.addTarget(self, action: #selector(objectsIsNotEmpty_v2), for: .editingChanged)
        touchCheckPasswordField.addTarget(self, action: #selector(objectsIsNotEmpty_v3), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        picker.allowsEditing = true
        return picker
    }()
    
    
    @objc func tapView(gestureRecognizer: UIGestureRecognizer) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = originalImage

            self.touchNextButton.isEnabled = self.isValidCheckButton() ? true : false
        }
        self.dismiss(animated: true, completion: nil)
        // 이 메소드가 실행이 되면 나머지 값들 데이터를 검증하는 소스를 추가해준다.
    }
    
    // 조건에 따라 버튼 비활성화 소스
    
    
    //    func setupAppTargetIsNotEmpyTextFields() {
    //        touchNextButton.isEnabled = false
    //        touchIDTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    //        touchPasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    //        touchCheckPasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    //
    //    }
    //
    //    @objc func textFieldsIsNotEmpty(sender: UITextField) {
    //        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
    //
    //        guard
    //            let id = touchIDTextField.text, !id.isEmpty,
    //            let password = touchPasswordField.text, !password.isEmpty,
    //            let checkpassword = touchCheckPasswordField.text, password == checkpassword,
    //            let textfield = touchTextView.text, !textfield.isEmpty
    //        else
    //        {
    //            self.touchNextButton.isEnabled = false
    //            return
    //        }
    //        touchNextButton.isEnabled = true
    //    }
    
    private func isValidCheckButton() -> Bool {
        guard
            let id = touchIDTextField.text, !id.isEmpty,
            let password = touchPasswordField.text, !password.isEmpty,
            let checkpassword = touchCheckPasswordField.text, password == checkpassword,
            let textfield = touchTextView.text, !textfield.isEmpty,
            self.imageView.image != nil
            else {
                return false
        }
        
        return true
    }
    
    @objc func objectsIsNotEmpty_v1(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let id = touchIDTextField.text, !id.isEmpty,
            let password = touchPasswordField.text, !password.isEmpty,
            let checkpassword = touchCheckPasswordField.text, password == checkpassword,
            let textfield = touchTextView.text, !textfield.isEmpty
            // 여기서 이미지 로딩 bool 값을 받아와서 설정해줘야 한다. 근데 bool 값을 가져올 수 있는 함수 또는 프로퍼티가 없다.
            else
        {
            self.touchNextButton.isEnabled = false
            return
        }
        touchNextButton.isEnabled = true
    }
    
    @objc func objectsIsNotEmpty_v2(sender: UITextField) {
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
        touchNextButton.isEnabled = true
    }
    
    @objc func objectsIsNotEmpty_v3(sender: UITextField) {
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
        touchNextButton.isEnabled = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.isValidCheckButton() {
            touchNextButton.isEnabled = true
        } else {
            self.touchNextButton.isEnabled = false
        }
    }
    
}

