//
//  File.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/10.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

//
//  Model.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/27.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

struct SecondAPIResponse: Codable {
    let movies2: [DetailContents]
}

struct DetailContents: Codable {
    
    let audience: Int
    let grade: Int
    let actor: String
    let duration: Int
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let director: String
    let id: String
    let image: String
    
    
    enum CodingKeys: String, CodingKey {
        case audience, grade, actor, duration, date,id, title, director, image
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}



