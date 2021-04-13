//
//  ViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//


import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkPasswordTextField: UITextField!
    @IBOutlet private weak var contentsTextView: UITextView!

    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    @IBAction func touchCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        UserInformation.shared.id = idTextField.text
        UserInformation.shared.password = passwordTextField.text
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        setContensTextView()
        setImageView()
        setNextButton()
        setTextField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.checkPasswordTextField.resignFirstResponder()
        self.contentsTextView.resignFirstResponder()
    }

    private func setContensTextView() {
        contentsTextView.delegate = self
    }

    private func setImageView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView(gestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
    }

    private func setNextButton() {
        nextButton.isEnabled = false
    }

    private func setTextField() {
        idTextField.addTarget(self, action: #selector(didEditTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didEditTextField), for: .editingChanged)
        checkPasswordTextField.addTarget(self, action: #selector(didEditTextField), for: .editingChanged)
    }

    @objc func tapView(gestureRecognizer: UIGestureRecognizer) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }

    @objc func didEditTextField(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        if self.isValidCheckButton() {
            nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }

    private func isValidCheckButton() -> Bool {
        guard
            let id = idTextField.text, !id.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let checkpassword = checkPasswordTextField.text, password == checkpassword,
            let textViewContents = contentsTextView.text, !textViewContents.isEmpty
//            self.imageView.image != nil
            else {
                return false
        }
        return true
    }
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
}

extension SignUpViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if self.isValidCheckButton() {
            nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
}
