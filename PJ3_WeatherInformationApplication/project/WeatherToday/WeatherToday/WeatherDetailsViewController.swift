//
//  ThirdViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/02.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController {

    var weatherModel: WeatherModel?

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAttributes()
        setUI()
    }

    private func setNavigationBarAttributes() {
        self.navigationController?.navigationBar.barTintColor = .blue
        self.navigationController?.navigationBar.tintColor = .white
    }

    private func setUI() {
        self.title = weatherModel?.cityName
        self.temperatureLabel.text = weatherModel?.celsiusString
        self.precipitationLabel.text = weatherModel?.rainfallProbabilityString

        switch weatherModel?.state {
        case 10: self.weatherImageView.image = UIImage(named: "sunny")
        case 11: self.weatherImageView.image = UIImage(named: "cloudy")
        case 12: self.weatherImageView.image = UIImage(named: "rainy")
        case 13: self.weatherImageView.image = UIImage(named: "snowy")
        default: self.weatherImageView.image = nil
        }

        switch weatherModel?.state {
        case 10: weatherLabel.text = "맑음"
        case 11: weatherLabel.text = "흐림"
        case 12: weatherLabel.text = "비"
        case 13: weatherLabel.text = "눈"
        default: weatherLabel.text = nil
        }

        guard let weatherModel = weatherModel else { return }
        if weatherModel.celsius < 10 {
            self.temperatureLabel.textColor = .blue
        } else {
            self.temperatureLabel.textColor = .black
        }
        if weatherModel.rainfallProbability > 50 {
            self.precipitationLabel.textColor = .orange
        } else {
            self.precipitationLabel.textColor = .black
        }
    }
}
