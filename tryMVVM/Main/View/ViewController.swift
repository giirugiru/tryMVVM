//
//  ViewController.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var usersTableView: UITableView!
  
  private var viewModel = UserListViewModel()
  private var networking = Networking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    usersTableView.dataSource = self
    usersTableView.reloadData()
    
    viewModel.users.bind { [weak self] _ in
      DispatchQueue.main.async {
        self?.usersTableView.reloadData()
      }
    }
    
    fetchData { result in
      switch result{
      case .success(let users):
        print(users)
        self.viewModel.users.value = users.compactMap({ user in
          UserTableViewCellViewModel(name: user.name)
        })
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchData(completion: ((Result<[User], ErrorResult>) -> Void)?){
    let url = "https://jsonplaceholder.typicode.com/users"
    networking.getRequest(urlString: url, completion: completion)
  }
  
  // Navigation
  @IBAction func BarButtonTapped(_ sender: UIBarButtonItem) {
    let vc = AccountListViewController(nibName: "AccountListViewController", bundle: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.users.value?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = viewModel.users.value?[indexPath.row].name

    return cell
  }
  
}

