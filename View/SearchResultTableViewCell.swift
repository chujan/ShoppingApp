//
//  SearchResultTableViewCell.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 07/12/2022.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultTableViewCell"
    
    private let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ImageView)
        contentView.addSubview(titleLabel)
        applyConstraints() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let ImageViewConstraints = [
            ImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: +15),
            ImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            ImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            ImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
      let  titleLabelConstraints = [
        titleLabel.leadingAnchor.constraint(equalTo: ImageView.trailingAnchor, constant: 25),
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
      ]
        NSLayoutConstraint.activate(ImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        
    }
     func configeModel(with model: TopItemModel) {
        ImageView.sd_setImage(with: model.thumbnail.asUrl)
        titleLabel.text = model.title
    }
    
   

}
