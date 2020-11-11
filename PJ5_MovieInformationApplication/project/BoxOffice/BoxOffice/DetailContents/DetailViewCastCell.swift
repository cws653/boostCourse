//
//  DetailViewCastCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/19.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class DetailViewCastCell: UITableViewCell {

    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func setUI(with movie: DetailContents) {
        
        self.directorLabel.text = movie.director
        self.actorLabel.text = movie.actor
    }
}
