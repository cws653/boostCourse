//
//  SecondViewController.swift
//  pj3_v1
//
//  Created by 최원석 on 2020/07/27.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var textToSet: String?
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textLabel.text = self.textToSet
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
