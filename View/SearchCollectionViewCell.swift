//
//  SearchCollectionViewCell.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 07/12/2022.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func  layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        titleLabel.frame = CGRect(x: 3, y: contentView.height-30, width: contentView.width-6, height: 30)
    }
    
    func configureModel(with model: TopItemModel) {
        imageView.sd_setImage(with: model.thumbnail.asUrl)
        titleLabel.text = model.title
    }
    
}
