//
//  DetailViewCommentCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/12.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class DetailViewCommentCell: UITableViewCell {
    
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var contents: UITextView!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    internal func setUI(with comment: Comment) {
        let date = Date(timeIntervalSince1970: comment.timestamp)
        let strDate = self.setDateFormatter().string(from: date)
        
        self.writer.text = comment.writer
        self.timestamp.text = "\(strDate)"
        self.contents.text = comment.contents
        
        self.setImages(with: comment.rating)
    }
    
    private func setDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    private func setImages(with rating: Double) {
        let defaultStarImage = UIImage(named: "ic_star_large")
        
        self.firstStar.image = nil
        self.secondStar.image = nil
        self.thirdStar.image = nil
        self.fourthStar.image = nil
        self.fifthStar.image = nil
        
        if let images = StarImageMaker.setStartImages(with: rating) {
            self.firstStar.image = images[safe: 0] ?? defaultStarImage
            self.secondStar.image = images[safe: 1] ?? defaultStarImage
            self.thirdStar.image = images[safe: 2] ?? defaultStarImage
            self.fourthStar.image = images[safe: 3] ?? defaultStarImage
            self.fifthStar.image = images[safe: 4] ?? defaultStarImage
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

struct StarImageMaker {
    static func setStartImages(with inputValue: Double) -> [UIImage?]? {
        let defaultStar = UIImage(named: "ic_star_large")
        let halfStar = UIImage(named: "ic_star_large_half")
        let fullStar = UIImage(named: "ic_star_large_full")
        
        switch round(inputValue) {
        case 0:
            return [defaultStar, defaultStar, defaultStar, defaultStar, defaultStar]
        case 1.0:
            return [halfStar, defaultStar, defaultStar, defaultStar, defaultStar]
        case 2.0:
            return [defaultStar, defaultStar, defaultStar, defaultStar, defaultStar]
        case 3.0:
            return [defaultStar, halfStar, defaultStar, defaultStar, defaultStar]
        case 4.0:
            return [defaultStar, defaultStar, defaultStar, defaultStar, defaultStar]
        case 5.0:
            return [fullStar, fullStar, halfStar, defaultStar, defaultStar]
        case 6.0:
            return [fullStar, fullStar, fullStar, defaultStar, defaultStar]
        case 7.0:
            return [fullStar, fullStar, fullStar, halfStar, defaultStar]
        case 8.0:
            return [fullStar, fullStar, fullStar, fullStar, defaultStar]
        case 9.0:
            return [fullStar, fullStar, fullStar, fullStar, halfStar]
        case 10.0:
            return [fullStar, fullStar, fullStar, fullStar, fullStar]
        default:
            return nil
        }
    }
}
