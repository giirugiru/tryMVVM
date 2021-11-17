//
//  AccountListViewModel.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import Foundation

protocol AccountListProtocol {
  func getAccountList(completion: ((Result<[Account], ErrorResult>) -> Void)?)
}

class AccountListViewModel: AccountListProtocol {
  func getAccountList(completion: ((Result<[Account], ErrorResult>) -> Void)?) {
    let url = "https://jsonplaceholder.typicode.com/users"
    Networking.shareInstance.getRequest(urlString: url, completion: completion)
  }
}
