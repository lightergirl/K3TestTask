//
//  PostTableViewCell.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 3/28/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var blogName: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    var readButtonHandler: (() -> Void)? {
        didSet {
            readButton.addTarget(self, action: #selector(readButtonTapped(_:)), for: .touchUpInside)
        }
    }
    @objc func readButtonTapped(_ sender: AnyObject?) {
        if let handler = readButtonHandler {
            handler()
        }
    }
}
