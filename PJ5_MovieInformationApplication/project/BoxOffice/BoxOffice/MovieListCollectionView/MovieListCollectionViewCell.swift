//
//  CustomCollectionViewCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/30.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView?
    @IBOutlet weak var gradeImageView: UIImageView?
    @IBOutlet weak var movieTitleLabel: UILabel?
    @IBOutlet weak var gradeAndRateLabel: UILabel?
    @IBOutlet weak var openDateLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.movieImageView?.image = nil
        self.gradeImageView?.image = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.movieImageView?.image = nil
        self.gradeImageView?.image = nil
    }

    func setupUI(model: Movies, data: Data) {
        self.movieImageView?.image = UIImage(data: data)

        switch model.grade {
        case 0: self.gradeImageView?.image = UIImage(named: "ic_allages")
        case 12: self.gradeImageView?.image = UIImage(named: "ic_12")
        case 15: self.gradeImageView?.image = UIImage(named: "ic_15")
        case 19: self.gradeImageView?.image = UIImage(named: "ic_19")
        default: self.gradeImageView?.image = nil
        }

        if self.movieTitleLabel?.adjustsFontSizeToFitWidth == false {
            self.movieTitleLabel?.adjustsFontSizeToFitWidth = true
        }

        self.movieTitleLabel?.text = model.title
        self.gradeAndRateLabel?.text = model.collectionReservationGrade + model.collectionUserRating + " / " + model.collectionReservationRate
        self.openDateLabel?.text = model.collectionOpenDate
    }
}
