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

//struct MovieDetail:Decodable {
//    let audience:Int
//    let actor:String
//    let duration:Int
//    let director: String
//    let synopsis: String
//    let genre:String
//    let grade:Int
//    let image:String
//    let reservation_grade:Int
//    let title:String
//    let reservation_rate:Double
//    let user_rating:Double
//    let date:String
//    let id:String
//}
//
