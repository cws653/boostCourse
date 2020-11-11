//
//  ThirdViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class DetailSignUpVC: UIViewController, UITextFieldDelegate {
    
    // Properties
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        phoneNumberTextField.text = UserInformation.shared.phoneNumber
        dateOfBirthLabel.text = UserInformation.shared.dateOfBirth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.signUpButton.isEnabled = false
        self.datePicker.addTarget(self, action: #selector(self.touchDatePicker(_:)), for: .valueChanged)
        self.phoneNumberTextField.addTarget(self, action: #selector(self.objectsIsNotEmpty), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.phoneNumberTextField.resignFirstResponder()
    }
    
    // 텍스트필드 액션함수
    @objc func objectsIsNotEmpty(sender: UITextField) {
        if isValidCheckButton() {
            self.signUpButton.isEnabled = true
        } else {
            self.signUpButton.isEnabled = false
        }
    }
    
    // datePicker 액션함수
    @IBAction func touchDatePicker(_ sender: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        let date = dateformatter.string(from: datePicker.date)
        dateOfBirthLabel.text = date
        
        if isValidCheckButton() {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
    }
    
    // signUpButton 액션함수
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        UserInformation.shared.phoneNumber = phoneNumberTextField.text
        UserInformation.shared.dateOfBirth = dateOfBirthLabel.text
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // previousButton 액션함수
    @IBAction func previousButtonAction(_ sender: UIButton) {
        UserInformation.shared.phoneNumber = phoneNumberTextField.text
        UserInformation.shared.dateOfBirth = dateOfBirthLabel.text
        self.dismiss(animated: true, completion: nil)
    }
    
    // 취소버튼 액션함수
    @IBAction func cancelButton(_ sender: UIButton) {
        UserInformation.shared.id = nil
        UserInformation.shared.password = nil
        UserInformation.shared.phoneNumber = nil
        UserInformation.shared.dateOfBirth = nil
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 생년월일, 전화번호 상태 감지 함수
    private func isValidCheckButton() -> Bool {
        guard
            let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
            let dateOfBirth = dateOfBirthLabel.text, !dateOfBirth.isEmpty
            else {
                return false
        }
        return true
    }
}
