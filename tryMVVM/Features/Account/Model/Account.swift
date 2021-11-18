//
//  Account.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import Foundation

struct Account: Codable {
  let username: String
  let email: String
}

struct PostResponse: Codable {
  let body: String
  let id: Int
  let title: String
  let userId: String
}
