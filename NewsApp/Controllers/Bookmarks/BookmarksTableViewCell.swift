//
//  BookmarksTableViewCell.swift
//  NewsApp
//
//  Created by Joel on 3/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BookmarksTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var srcImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
