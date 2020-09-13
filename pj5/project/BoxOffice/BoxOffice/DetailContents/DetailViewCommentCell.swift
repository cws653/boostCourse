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
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    internal func setUI(with comment: Comment) {
        self.writer.text = comment.writer
        let date = Date(timeIntervalSince1970: comment.timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        
        self.star1.image = nil
        self.star2.image = nil
        self.star3.image = nil
        self.star4.image = nil
        self.star5.image = nil
        
        switch comment.rating {
        case 0...1.0:
            self.star1.image = UIImage(named: "ic_star_large_half")
        case 1.1...2.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
        case 2.1...3.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_half")
        case 3.1...4.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
        case 4.1...5.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
            self.star3.image = UIImage(named: "ic_star_large_half")
        case 5.1...6.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
            self.star3.image = UIImage(named: "ic_star_large_full")
        case 6.1...7.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
            self.star3.image = UIImage(named: "ic_star_large_full")
            self.star4.image = UIImage(named: "ic_star_large_half")
        case 7.1...8.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
            self.star3.image = UIImage(named: "ic_star_large_full")
            self.star4.image = UIImage(named: "ic_star_large_full")
        case 8.1...9.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
            self.star3.image = UIImage(named: "ic_star_large_full")
            self.star4.image = UIImage(named: "ic_star_large_full")
            self.star5.image = UIImage(named: "ic_star_large_half")
        case 9.1...10.0:
            self.star1.image = UIImage(named: "ic_star_large_full")
            self.star2.image = UIImage(named: "ic_star_large_full")
            self.star3.image = UIImage(named: "ic_star_large_full")
            self.star4.image = UIImage(named: "ic_star_large_full")
            self.star5.image = UIImage(named: "ic_star_large_full")
        default:
            break
        }
        self.timestamp.text = "\(strDate)"
        self.contents.text = comment.contents
    }
}
