//
//  PostTableViewCell.swift
//  Firebase Crash Course
//
//  Created by mac on 6/13/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
