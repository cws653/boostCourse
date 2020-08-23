//
//  ViewController.swift
//  SignUp_v2
//
//  Created by 최원석 on 2020/07/25.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        okButton.isEnabled = false
        okButton.setTitleColor(.gray, for: .normal)
    }

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheck: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    
    
}

