//
//  PhotoViewController.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 15/12/2022.
//

import UIKit
import SDWebImage

class PhotoViewController: UIViewController {
    private let url: URL

   
    init(with url: URL) {
        self.url  = url
        super.init(nibName: nil, bundle: nil)
        
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.sd_setImage(with: self.url, completed: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    

   
}
