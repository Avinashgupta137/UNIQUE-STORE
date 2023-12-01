//
//  UserModel.swift
//  Shopping-App-eCommerce
//
//  Created by Avinash on 1.12.2023.
//

import Foundation

struct User: Codable {
    var id: String?
    var username: String?
    var email: String?
    var cart: [Int : Int]?
}
