//
//  DetailViewPosterCell.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/12.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

//protocol CellSetable where Self: UITableViewCell {
//    func setUI(with movie: DetailContents)
//}

class DetailViewPosterCell: UITableViewCell {
    
    @IBOutlet weak var imageOfMovie: UIImageView!
    @IBOutlet weak var titleOfMovie: UILabel!
    @IBOutlet weak var openDay: UILabel!
    @IBOutlet weak var genreAndDuration: UILabel!
    @IBOutlet weak var reservation_rate: UILabel!
    @IBOutlet weak var user_rating: UILabel!
    @IBOutlet weak var audience: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    @IBOutlet weak var imageOfGrade: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    internal func setUI(with movie: DetailContents) {
        guard let url = URL(string: movie.image) else {
            return
        }
        self.imageOfMovie.image = UIImage(named: "cinema")
        self.imageOfMovie.load(url: url)
        self.titleOfMovie.text = movie.title
        self.openDay.text = movie.date
        self.genreAndDuration.text = movie.genre + "/" + String(movie.duration)
        self.reservation_rate.text = "\(movie.reservationRate)"
        self.user_rating.text = "\(movie.userRating)"
        self.audience.text = "\(movie.audience)"
        
        switch movie.grade {
        case 0: imageOfGrade.image = UIImage(named: "ic_allages")
        case 12: imageOfGrade.image = UIImage(named: "ic_12")
        case 15: imageOfGrade.image = UIImage(named: "ic_15")
        case 19: imageOfGrade.image = UIImage(named: "ic_19")
        default: break
        }
        
        switch round(movie.userRating) {
        case 0:
            firstStar?.image = UIImage(named: "ic_star_large")
            secondStar?.image = UIImage(named: "ic_star_large")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 1.0:
            firstStar?.image = UIImage(named: "ic_star_large_half")
            secondStar?.image = UIImage(named: "ic_star_large")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 2.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 3.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_half")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 4.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 5.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_half")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 6.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 7.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_half")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 8.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_full")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 9.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_full")
            fifthStar?.image = UIImage(named: "ic_star_large_half")
        case 10.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_full")
            fifthStar?.image = UIImage(named: "ic_star_large_full")
        default:
            break
        }
    }
    
}


extension UIImageView {
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func load(url: URL) {
        getData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self?.image = UIImage(data: data)
            }
        }
    }
}
