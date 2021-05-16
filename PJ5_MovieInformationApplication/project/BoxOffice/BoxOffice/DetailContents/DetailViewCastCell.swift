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
    
    internal func setUI(with movie: DetailContents) {
        
        self.directorLabel.text = movie.director
        self.actorLabel.text = movie.actor
    }
}
