//
//  UserNewsCell.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/6/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsCell: UITableViewCell {

    @IBOutlet weak var UNewsImage: UIImageView!
    
    @IBOutlet weak var UNameLabel: UILabel!
    
    @IBOutlet weak var UDateLabel: UILabel!
    
    @IBOutlet weak var UsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
