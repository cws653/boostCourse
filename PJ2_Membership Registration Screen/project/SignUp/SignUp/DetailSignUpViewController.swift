//
//  ThirdViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class DetailSignUpViewController: UIViewController {

    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!

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

    @IBAction func clickSignUpButton(_ sender: UIButton) {
        UserInformation.shared.phoneNumber = phoneNumberTextField.text
        UserInformation.shared.dateOfBirth = dateOfBirthLabel.text
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func previousButtonAction(_ sender: UIButton) {
        UserInformation.shared.phoneNumber = phoneNumberTextField.text
        UserInformation.shared.dateOfBirth = dateOfBirthLabel.text
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        UserInformation.shared.id = nil
        UserInformation.shared.password = nil
        UserInformation.shared.phoneNumber = nil
        UserInformation.shared.dateOfBirth = nil

        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setSignUpButton()
        setDatePicker()
        setPhoneNumberTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dateOfBirthLabel.text = UserInformation.shared.dateOfBirth
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.phoneNumberTextField.resignFirstResponder()
    }

    private func setSignUpButton() {
        self.signUpButton.isEnabled = false
    }

    private func setDatePicker() {
        self.datePicker.addTarget(self, action: #selector(self.touchDatePicker(_:)), for: .valueChanged)
    }

    private func setPhoneNumberTextField() {
        self.phoneNumberTextField.addTarget(self, action: #selector(self.didEditTextField), for: .editingChanged)
    }

    @objc func didEditTextField(sender: UITextField) {
        if isValidCheckButton() {
            self.signUpButton.isEnabled = true
        } else {
            self.signUpButton.isEnabled = false
        }
    }

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
