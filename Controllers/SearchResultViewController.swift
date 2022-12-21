//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 07/12/2022.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    
}

class SearchResultViewController: UIViewController {
    var search = [TopItem]()
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public var searchtableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        return tableView
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchtableView)
        searchtableView.separatorStyle = .none
        
        searchtableView.delegate = self
        searchtableView.dataSource = self

        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchtableView.frame = view.bounds
    }
    

    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = search[indexPath.row]
        cell.configeModel(with: TopItemModel(title: viewModel.title, thumbnail: viewModel.thumbnail))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        let model = search[indexPath.row]
        let vc = TopItemViewController(topItem: model)
        vc.title = model.title
        vc.configureModels(with: ProductDetailModel(price: model.price, discountPercentage: model.discountPercentage, rating: model.rating, thumbnail: model.thumbnail, brand: model.brand, productDescription: model.productDescription))
        vc.navigationItem.largeTitleDisplayMode = .never
        present(vc, animated: true)
    }
    
    
}
