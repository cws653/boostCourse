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
        
        self.setImages(with: movie.userRating)
        
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
