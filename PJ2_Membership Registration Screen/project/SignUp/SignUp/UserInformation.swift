//
//  UserInformation.swift
//  SignUp_v3
//
//  Created by 최원석 on 2020/09/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var password: String?
    var phoneNumber: String?
    var dateOfBirth: String?
}
