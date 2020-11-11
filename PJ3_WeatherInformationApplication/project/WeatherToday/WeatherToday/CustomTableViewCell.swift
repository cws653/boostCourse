//
//  CustomTableViewCell.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/03.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customFirstLabel: UILabel!
    @IBOutlet weak var customSecondLabel: UILabel!
    @IBOutlet weak var customThirdLabel: UILabel!
    @IBOutlet weak var customButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.accessoryType = .detailDisclosureButton
    }
}
