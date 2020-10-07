//
//  DetailViewContentsCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/12.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class DetailViewContentsCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    internal func setUI(with movie: DetailContents) {
        
        self.content.text = movie.synopsis
        self.content.isScrollEnabled = false
        self.content.isEditable = false
    }
}
