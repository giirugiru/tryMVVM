//
//  AccountListViewController.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import UIKit

final class AccountListViewController: UIViewController {
  
  @IBOutlet weak var accountTableView: UITableView!
  
  private var viewModel = AccountListViewModel()
  private var observableViewModel = AccountObservable()
  
  // MARK: - LIFECYCLE
  override func viewDidLoad() {
    super.viewDidLoad()
    accountTableView.dataSource = self
    accountTableView.delegate = self
    setupObserver()
    getAccountList()
  }
  
  // MARK: - SETUP
  fileprivate func setupObserver(){
    observableViewModel.accounts.bind { [weak self] _ in
      DispatchQueue.main.async {
        self?.accountTableView.reloadData()
      }
    }
  }
  
  // MARK: - HELPERS
  fileprivate func getAccountList(){
    viewModel.getAccountList { result in
      switch result{
      case .success(let accounts):
        print(accounts)
        self.observableViewModel.accounts.value = accounts
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  fileprivate func postAccount(param: Account){
    viewModel.postAccount(param: param) { result in
      switch result{
      case.success(let response):
        print (response)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

extension AccountListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return observableViewModel.accounts.value?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    let model = observableViewModel.accounts.value?[indexPath.row]
    cell.textLabel?.text = model?.username
    cell.detailTextLabel?.text = model?.email
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let model = observableViewModel.accounts.value?[indexPath.row] else { return }
    postAccount(param: model)
  }
  
}
