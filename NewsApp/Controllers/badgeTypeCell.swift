//
//  badgeTypeCell.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class badgeTypeCell: UITableViewCell {
    
    @IBOutlet weak var badgeTypeImageView: UIImageView!
    @IBOutlet weak var badgeTypeTitleLabel: UILabel!
    @IBOutlet weak var badgeTypeProgressionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
