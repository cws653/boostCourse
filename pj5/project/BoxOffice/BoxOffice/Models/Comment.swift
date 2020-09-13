//
//  Comment.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/12.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

struct CommentList: Decodable {
    let comments: [Comment]
    let movie_id: String
}

struct Comment: Decodable {
    let rating:Double
    let timestamp:Double
    let writer: String
    let movie_id: String
    let contents: String
}


