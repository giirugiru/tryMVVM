//
//  AccountListViewModel.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import Foundation
import UIKit

protocol AccountListProtocol {
  func getAccountList(completion: ((Result<[Account], ErrorResult>) -> Void)?)
  func postAccount(param: Account, completion: ((Result<PostResponse, ErrorResult>) -> Void)?)
}

struct AccountObservable {
  var accounts: Observable<[Account]> = Observable([])
}

final class AccountListViewModel: AccountListProtocol {
  
  var observableViewModel = AccountObservable()
  weak var presenter: AccountListPresenterProtocol?
  
  init(presenter: AccountListPresenterProtocol) {
    self.presenter = presenter
  }
  
  func setupObserver(){
    observableViewModel.accounts.bind { [weak self] _ in
      self?.presenter?.layoutData()
    }
  }
  
  func getAccountList(completion: ((Result<[Account], ErrorResult>) -> Void)?) {
    let url = "https://jsonplaceholder.typicode.com/users"
    Networking.shareInstance.getRequest(urlString: url, completion: completion)
  }
  
  func postAccount(param: Account, completion: ((Result<PostResponse, ErrorResult>) -> Void)?) {
    let url = "https://jsonplaceholder.typicode.com/posts"
    
    let parameters: [String: Any] = [
      "title": param.username,
      "body": param.email,
      "userId": UIDevice.current.identifierForVendor?.uuidString ?? 0
    ]
    
    Networking.shareInstance.postRequest(urlString: url, parameters: parameters, completion: completion)
  }
}
