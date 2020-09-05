//
//  SecondTableViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/01.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class SecondTableViewController: UIViewController {
    
    var textToSetTitle: String?
    @IBOutlet weak var uiView1: UIView?
    @IBOutlet weak var textLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 네비게이션바 설정 소스
        self.title = textToSetTitle
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // textLabel 설정
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.numberOfLines = 0
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
