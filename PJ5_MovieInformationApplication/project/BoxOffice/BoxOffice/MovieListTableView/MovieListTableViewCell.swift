//
//  CustomTableViewCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/29.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var thumbImageView: UIImageView?
    @IBOutlet private weak var gradeImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var rateLabel: UILabel?
    @IBOutlet private weak var openDateLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.thumbImageView?.image = nil
        self.gradeImageView?.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbImageView?.image = nil
        self.gradeImageView?.image = nil
    }

    func setupUI(model: Movies, data: Data) {
        self.thumbImageView?.image = UIImage(data: data)

        switch model.grade {
        case 0: self.gradeImageView?.image = UIImage(named: "ic_allages")
        case 12: self.gradeImageView?.image = UIImage(named: "ic_12")
        case 15: self.gradeImageView?.image = UIImage(named: "ic_15")
        case 19: self.gradeImageView?.image = UIImage(named: "ic_19")
        default: self.gradeImageView?.image = nil
        }

        self.titleLabel?.text = model.title
        self.rateLabel?.text = model.tableUserRating + " " + model.tableReservationGrade + " " + model.tableReservationRate
        self.openDateLabel?.text = model.tableOpenDate
    }

}
