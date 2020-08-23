//
//  Image.swift
//  MyAlbumV1
//
//  Created by 최원석 on 2020/08/17.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

struct Image: Codable {
    
//    {
//      "size" : "20x20",
//      "idiom" : "iphone",
//      "filename" : "NotificationIcon@2x.png",
//      "scale" : "2x"
//    }
    
    let size: String
    let idiom: String
    let filename: String
    let scale: String
}
