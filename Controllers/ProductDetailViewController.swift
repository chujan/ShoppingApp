//
//  ProductDetailViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 08/12/2022.
//

import UIKit
import SDWebImage
class ProductDetailViewController: UIViewController {
    var trending: Product?
   
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12 , weight:.thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let InstructionLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .systemRed
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let ratingLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .systemGray
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let brandLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .systemBrown
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let dicountLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .systemCyan
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let priceLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "$"
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let ratingsLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Rating"
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let brandsLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Brand"
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()
    private let discountLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Discount"
           label.font = .systemFont(ofSize: 15, weight:.bold)
           label.numberOfLines = 0
           return label
           
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(heroImageView)
        view.addSubview(InstructionLabel)
        view.addSubview(overViewLabel)
        view.addSubview(priceLabel)
        view.addSubview(ratingLabel)
        view.addSubview(dicountLabel)
        view.addSubview(brandLabel)
        view.addSubview(ratingsLabel)
        view.addSubview(brandsLabel)
        view.addSubview(discountLabel)
    }
    init(trending: Product) {
        self.trending = trending
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        heroImageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        InstructionLabel.frame = CGRect(x:view.right-200, y: heroImageView.bottom, width: view.width-5, height: 20)
        ratingLabel.frame = CGRect(x:view.right-200, y: InstructionLabel.bottom, width: view.width-5, height: 20)
        brandLabel.frame = CGRect(x:view.right-200, y:ratingLabel.bottom, width: view.width-5, height: 20)
        dicountLabel.frame = CGRect(x:view.right-200, y: brandLabel.bottom, width: view.width-5, height: 20)
       priceLabel.frame = CGRect(x: 10, y: heroImageView.bottom, width: view.width-5, height: 20)
        ratingsLabel.frame = CGRect(x: 10, y: priceLabel.bottom, width: view.width-5, height: 20)
        brandsLabel.frame = CGRect(x: 10, y: ratingsLabel.bottom, width: view.width-5, height: 20)
        discountLabel.frame = CGRect(x: 10, y: brandsLabel.bottom, width: view.width-5, height: 20)
     overViewLabel.frame = CGRect(x: 10, y: InstructionLabel.bottom, width: view.width-20, height: 200)
        
    }
    
    func configureModels(with model: ProductDetailModel) {
        heroImageView.sd_setImage(with: model.thumbnail.asUrl)
        overViewLabel.text = model.productDescription
        ratingLabel.text = model.rating.formatted()
        brandLabel.text = model.brand
        dicountLabel.text = model.discountPercentage.formatted()
        
        
        InstructionLabel.text = String(model.price)
    }
    
    
   

}
extension Double {
    var string: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 5
        formatter.roundingMode = .floor
        return formatter.string(for: self) ?? description
    }
    
}


  
    




