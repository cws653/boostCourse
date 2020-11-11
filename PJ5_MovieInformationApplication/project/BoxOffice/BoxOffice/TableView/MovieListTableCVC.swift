//
//  CustomTableViewCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/29.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieListTableCVC: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView?
    @IBOutlet weak var gradeImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var rateLabel: UILabel?
    @IBOutlet weak var openDateLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbImageView?.image = nil
        self.gradeImageView?.image = nil
    }

}
