//
//  WeatherModel.swift
//  WeatherToday
//
//  Created by 최원석 on 2021/04/14.
//  Copyright © 2021 최원석. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {

    let cityName: String
    let state: Int
    let celsius: Double
    let rainfallProbability: Int

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case state, celsius
        case rainfallProbability = "rainfall_probability"
    }

    var celsiusString: String {
        return "섭씨 " + "\(self.celsius)" + "도 / " + "화씨 " + "\(self.celsius + 32)" + "도"
    }

    var rainfallProbabilityString: String {
        return "강수확률 " + "\(self.rainfallProbability)" + "%"
    }
}
