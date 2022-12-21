//
//  NewConversationViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 10/12/2022.
//

import UIKit

class NewConversationViewController: UIViewController {
    public var completion: ((SearchResult) -> (Void))?
    
    private var users = [[String: String]]()
    private var results = [SearchResult]()
    private var hasFetched = false
    private let searchBar: UISearchBar = {
      let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(NewConversationTableViewCell.self, forCellReuseIdentifier: NewConversationTableViewCell.identifier)
        return table
        
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        view.backgroundColor = .systemBackground

       
    }
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    

    

}
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.replacingOccurrences(of: "", with: "") .isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        self.seaarchUsers(query: text)
        
        
        
    }
    func seaarchUsers(query: String) {
        if hasFetched {
            filterUsers(with: query)
            
        }
        else {
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case.success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case.failure(let error):
                    print("Failed to get users: \(error)")
                }
                
            })
        }
        
    }
    
    func filterUsers(with term: String) {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        let results : [SearchResult] = self.users.filter({
            guard let email = $0["email"],
                  email != safeEmail else {
                return false
            }
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
            
        }).compactMap({
            guard let email = $0["email"],
                  email != safeEmail,
            let name = $0["name"] else {
                return nil
            }
            
            return SearchResult(name: name, email: email)
            
        })
        self.results = results
        updateUI()
        
    }
    func updateUI() {
        if results.isEmpty {
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else {
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            
        }
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationTableViewCell.identifier, for: indexPath) as! NewConversationTableViewCell
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
            
        })
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}

struct SearchResult {
    let name: String
    let email: String
}
