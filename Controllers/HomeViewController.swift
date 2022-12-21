//
//  HomeViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 06/12/2022.
//

import UIKit
import FirebaseAuth
enum BrowseSectionType {
    case Product(viewModel: [CategoryModel])
    case  NewArrival(viewModel: [NewArrivalModel])
    case TopItem(viewModel: [TopItemModel])
    
    var title: String {
        switch self {
            
        case .Product:
            return "Category"
        case .NewArrival:
            return "NewArrival"
        case .TopItem:
            return "TopItem"
        }
    }
}

class HomeViewController: UIViewController {
    var category: [Product] = []
    var newArrival: [NewArrival] = []
    var topIem: [TopItem] = []
    
    var sections = [BrowseSectionType]()
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeViewController.createSectionLayout(section: sectionIndex)
        
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchData()
        validateAuth()
        
        

        view.backgroundColor = .systemBackground
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        var Product: categoryResponse?
        var NewArrival: NewArrivalResponse?
        var TopItem: TopItemResponse?
        APICaller.shared.getCategory { result in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model):
                Product = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        APICaller.shared.getFurniture { result in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model):
                NewArrival = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        APICaller.shared.getTopItem { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                TopItem = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        group.notify(queue: .main) {
            guard let Product = Product?.products,
                  let NewArrival = NewArrival?.products,
            let TopItem = TopItem?.products else {
                return
            }
            self.configureModels(category: Product, newArrival: NewArrival, topItem: TopItem)
        }
        
    }
    
    func configureModels(category: [Product], newArrival: [NewArrival], topItem: [TopItem]) {
        self.category = category
        self.newArrival = newArrival
        self .topIem = topItem
        sections.append(.Product(viewModel: category.compactMap({ return CategoryModel(category: $0.category, thumbnail: $0.thumbnail)
           
        })))
        sections.append(.NewArrival(viewModel: newArrival.compactMap({ return
            NewArrivalModel(title: $0.title, thumbnail: $0.thumbnail)
        })))
        
        sections.append(.TopItem(viewModel: topItem.compactMap({ return
            TopItemModel(title: $0.title, thumbnail: $0.thumbnail)
        })))
        
        collectionView.reloadData()
        
    }
    
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
       
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(NewArrivalCollectionViewCell.self, forCellWithReuseIdentifier: NewArrivalCollectionViewCell.identifier)
        collectionView.register(TopItemCollectionViewCell.self, forCellWithReuseIdentifier: TopItemCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
    }
    
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
            
            let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(260)), subitem: item, count: 1)
            
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(260)), subitem: verticalgroup, count: 1)
            
            
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 2, bottom: 2, trailing: 8)
            let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)), subitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitem: verticalgroup, count: 1)
            
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior  = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(140)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
            let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(200)), subitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(200)), subitem: verticalgroup, count: 1)
            
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 1)
              let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
        
    }
    

   
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case.Product(let viewModel):
            return viewModel.count
       
        case .NewArrival(let viewModel):
            return viewModel.count
        case .TopItem(let viewModel):
            return viewModel.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case.Product(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier , for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)
            return cell
           
        case .NewArrival(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArrivalCollectionViewCell.identifier, for: indexPath) as? NewArrivalCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configureModel(with: viewModel)
            return cell
        case .TopItem(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopItemCollectionViewCell.identifier, for: indexPath) as? TopItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configureModel(with: viewModel)
            return cell
        }
       
        
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
       
        switch section {
        case .Product:
            let trending = category[indexPath.row]
            let vc = ProductDetailViewController(trending: trending)
            vc.title = trending.category
            vc.configureModels(with: ProductDetailModel(price: trending.price, discountPercentage: trending.discountPercentage, rating: trending.rating, thumbnail: trending.thumbnail, brand: trending.brand, productDescription: trending.productDescription))
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .NewArrival:
            let trending = newArrival[indexPath.row]
            let vc = NewArrivalViewController(category: trending)
            vc.title = trending.category
            vc.configureModels(with: ProductDetailModel(price: trending.price, discountPercentage: trending.discountPercentage, rating: trending.rating, thumbnail: trending.thumbnail, brand: trending.brand, productDescription: trending.productDescription))
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .TopItem:
            let trending = topIem[indexPath.row]
            let vc = TopItemViewController(topItem: trending)
            vc.title = trending.title
            vc.configureModels(with: ProductDetailModel(price: trending.price, discountPercentage: trending.discountPercentage, rating: trending.rating, thumbnail: trending.thumbnail, brand: trending.brand, productDescription: trending.productDescription))
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    
}
