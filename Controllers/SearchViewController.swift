//
//  SearchViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 06/12/2022.
//

import UIKit

class SearchViewController: UIViewController, SearchResultViewControllerDelegate {
    var search = [TopItem]()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return collectionView

    }()
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "Search For Product"
        return vc

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        fetchData()
        view.backgroundColor = .systemBackground
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        collectionView.frame = view.bounds
    }
    
    private func fetchData() {
        APICaller.shared.getSearch { [weak self] result in
            switch result {
            case.success(let model):
                DispatchQueue.main.async {
                    self?.search = model
                    self?.collectionView.reloadData()
                }
               
            case.failure(let error):
                print(error.localizedDescription)
                
                
            }
        }
        
        
    }
    

    

}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = search[indexPath.row]
        cell.configureModel(with: TopItemModel(title: viewModel.title, thumbnail: viewModel.thumbnail))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = search[indexPath.row]
        let vc = TopItemViewController(topItem: model)
        vc.title = model.title
        vc.configureModels(with: ProductDetailModel(price: model.price, discountPercentage: model.discountPercentage, rating: model.rating, thumbnail: model.thumbnail, brand: model.brand, productDescription: model.productDescription))
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController,
              let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        APICaller.shared.getSearchResult(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let model):
                    DispatchQueue.main.async {
                       resultsController.search = model
                        print(model)
                        resultsController.searchtableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    
}
