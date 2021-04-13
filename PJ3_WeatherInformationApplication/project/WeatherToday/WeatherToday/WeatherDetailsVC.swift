//
//  ThirdViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/02.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class WeatherDetailsVC: UIViewController {
    
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    
    var setWeatherImageView: UIImage?
    var cityName: String?
    var setTemperatureLabel: String?
    var setPrecipitationLabel: String?
    var stateOfWeather: Int?
    var setTemperatureLabelColor: UIColor?
    var setPrecipitationLabelColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barTintColor = .blue
        self.navigationController?.navigationBar.tintColor = .white
        self.title = cityName
        
        self.temperatureLabel.text = setTemperatureLabel
        self.precipitationLabel.text = setPrecipitationLabel
        self.weatherImageView.image = setWeatherImageView
        self.temperatureLabel.textColor = setTemperatureLabelColor
        self.precipitationLabel.textColor = setPrecipitationLabelColor
        
        switch stateOfWeather {
        case 10: weatherLabel.text = "맑음"
        case 11: weatherLabel.text = "흐림"
        case 12: weatherLabel.text = "비"
        case 13: weatherLabel.text = "눈"
        default: weatherLabel.text = nil
        }
    }
}
