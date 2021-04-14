//
//  Country.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/01.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

struct CountryModel: Decodable {
    
    let koreanName: String
    let assetName: String
    
    enum  CodingKeys: String, CodingKey{
        case koreanName = "korean_name"
        case assetName = "asset_name"
    }
}

