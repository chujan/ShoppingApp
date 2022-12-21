//
//  NewConversationTableViewCell.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 17/12/2022.
//

import UIKit
import SDWebImage

class NewConversationTableViewCell: UITableViewCell {
    static let identifier = "NewConversationTableViewCell"
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
        
    }()
    
   

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        userNameLabel.frame = CGRect(x: userImageView.right + 10, y: 20, width: contentView.width - 20 - userImageView.width, height: 50)
       
       
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with model: SearchResult) {
       
        self.userNameLabel.text = model.name
        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case.success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
            case.failure(let error):
                print("failed to get image url:\(error)")
            }
            
            
        })
        
    }
    
    

   

}
