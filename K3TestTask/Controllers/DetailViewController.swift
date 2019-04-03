//
//  DetailViewController.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 4/1/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var sorryLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var imaheHeightConstraint: NSLayoutConstraint!
    var detailPost: DetailPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        guard let detail = detailPost, let type = detail.type, let imageHeight = detail.imageHeight, let blogName = detail.blogName else { return }
        blogNameLabel.text = blogName
        switch type {
        case .photo:
            sorryLabel.isHidden = true
            if let imageUrl = detail.image {
                contentImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available.jpeg"))
            } else {
                contentImage.image = UIImage(named: "no_image_available.jpeg")
            }
            imaheHeightConstraint.constant = imageHeight
        case .notPhoto:
            contentImage.image = UIImage(named: "no_image_available.jpeg")
            imaheHeightConstraint.constant = contentImage.bounds.width
        }
        view.layoutIfNeeded()
    }
}
