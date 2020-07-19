//
//  BadgeTableViewCell.swift
//  NewsApp
//
//  Created by 145532G  on 7/19/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {

    @IBOutlet weak var BadgeImageView: UIImageView!
    @IBOutlet weak var BadgeCategoryLabel: UILabel!
    @IBOutlet weak var BadgeProgressionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
