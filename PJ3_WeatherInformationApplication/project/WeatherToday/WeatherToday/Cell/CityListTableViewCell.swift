//
//  CustomTableViewCell.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/03.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    var weatherModel: WeatherModel? {
        didSet {
            self.setUI()
        }
    }
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!

    func setUI() {
        self.selectionStyle = .none
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cityNameLabel.text = weatherModel?.cityName
        temperatureLabel.text = weatherModel?.celsiusString
        precipitationLabel.text = weatherModel?.rainfallProbabilityString

        switch weatherModel?.state {
        case 10: self.weatherImageView.image = UIImage(named: "sunny")
        case 11: self.weatherImageView.image = UIImage(named: "cloudy")
        case 12: self.weatherImageView.image = UIImage(named: "rainy")
        case 13: self.weatherImageView.image = UIImage(named: "snowy")
        default: self.weatherImageView.image = nil
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
