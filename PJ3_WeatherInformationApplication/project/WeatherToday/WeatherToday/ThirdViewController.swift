//
//  ThirdViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/02.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    
    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    
    var setUiImageView: UIImage?
    var textToSetTitle: String?
    var setSecondLabel: String?
    var setThirdLabel: String?
    var returnStateOfWeather: Int?
    var setSecondLabelColor: UIColor?
    var setThirdLabelColor: UIColor?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barTintColor = .blue
        self.title = textToSetTitle
        self.navigationController?.navigationBar.tintColor = .white
        
        self.secondLabel.text = setSecondLabel
        self.thirdLabel.text =  setThirdLabel
        self.uiImageView.image = setUiImageView
        self.secondLabel.textColor = setSecondLabelColor
        self.thirdLabel.textColor = setThirdLabelColor
       
        if self.secondLabel.adjustsFontSizeToFitWidth || self.thirdLabel.adjustsFontSizeToFitWidth == false {
            self.secondLabel.adjustsFontSizeToFitWidth = true
            self.thirdLabel.adjustsFontSizeToFitWidth = true
        }
        
        switch returnStateOfWeather {
        case 10:
            firstLabel.text = "맑음"
        case 11:
            firstLabel.text = "흐림"
        case 12:
            firstLabel.text = "비"
        case 13:
            firstLabel.text = "눈"
        default:
            firstLabel.text = nil
        }
        
       
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
