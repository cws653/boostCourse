//
//  ThirdViewController.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/07/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.datePicker.addTarget(self, action: #selector(self.touchDatePicker(_:)), for: UIControl.Event.valueChanged)
    }
    
    // 취소버튼을 통해 화면취소하는 소스
    
    @IBAction func touchSecondCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 데이트픽커 작동하면 해당 데이터 날짜라벨로 보내주는 소스
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @IBAction func touchDatePicker(_ sender: UIDatePicker) {
        let date: Date = self.datePicker.date
        let dateString: String = self.dateFormatter.string(from: date)
        self.dateLabel.text = dateString
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
