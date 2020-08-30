//
//  Model.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/27.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let movies: [Movies]
}

struct Movies: Codable {
    
//    let grade: Int
//    let thumb:String
//    let reservation_grade: Int
//    let title: String
//    let reservation_rate: Double
//    let user_rating: Double
//    let date: String
//    let id: String
    
    let grade: Int
    let thumb:String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var resetReservationRate: String {
        return "예매율: " + String(self.reservationRate)
    }
    var resetReservationGrade: String {
        return "예매순위: " + String(self.reservationGrade)
    }
    var resetUserRating: String {
        return "평점: " + String(self.userRating)
    }
    var resetDate: String {
        return "개봉일: " + self.date
    }
    
    enum CodingKeys: String, CodingKey {
        case grade, thumb, date, id, title
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}



//
//struct Movies: Codable {
//    let grade: Int
//    let thumb:String
//    let reservation_grade: Int
//    let title: String
//    let reservation_rate: Double
//    let user_rating: Double
//    let date: String
//    let id: String
//}
