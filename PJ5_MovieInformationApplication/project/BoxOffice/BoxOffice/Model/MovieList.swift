//
//  Model.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/27.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let movies: [Movies]
    let order_type: Int
}

struct Movies: Codable {
    
    let grade: Int
    let thumb: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    // 테이블뷰용
    var tableReservationRate: String {
        return "예매율: " + String(self.reservationRate)
    }
    var tableReservationGrade: String {
        return "예매순위: " + String(self.reservationGrade)
    }
    var tableUserRating: String {
        return "평점: " + String(self.userRating)
    }
    var tableOpenDate: String {
        return "개봉일: " + self.date
    }
    
    // 컬렉션뷰용
    var collectionReservationRate: String {
        return String(reservationRate) + "%"
    }
    var collectionReservationGrade: String {
        return String(reservationGrade) + "위"
    }
    var collectionUserRating: String {
        return "(" + String(userRating) + ")"
    }
    var collectionOpenDate: String {
        return self.date
    }
    
    enum CodingKeys: String, CodingKey {
        case grade, thumb, date, id, title
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}



