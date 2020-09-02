//
//  CustomTableViewCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/29.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customImageView1: UIImageView?
    @IBOutlet weak var customImageView2: UIImageView?
    @IBOutlet weak var customLabel1: UILabel?
    @IBOutlet weak var customLabel2: UILabel?
    @IBOutlet weak var customLabel3: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
