//
//  FirstViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        idTextField.text = UserInformation.shared.id
    }
}
