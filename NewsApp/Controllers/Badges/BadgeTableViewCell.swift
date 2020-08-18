//
//  BadgeTableViewCell.swift
//  NewsApp
//
//  Created by Joel on 18/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
