//
//  UserInformation.swift
//  SignUp_v1
//
//  Created by 최원석 on 2020/07/25.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var password: String?
    var checkpassword: String?
    var cellphonenumber: String?
}
