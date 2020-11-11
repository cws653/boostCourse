//
//  Userinformation.swift
//  pj2_v1
//
//  Created by 최원석 on 2020/07/18.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

class UserInformation
{
    static let shared: UserInformation = UserInformation()
    
    var name: String?
    var age: String?
}
