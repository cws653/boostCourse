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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    internal func setUI(with movie: DetailContents) {
        let url = URL(string: movie.image)!
        self.imageOfMovie.image = UIImage(named: "cinema")
        self.imageOfMovie.load(url: url)
        self.titleOfMovie.text = movie.title
        self.openDay.text = movie.date
        self.genreAndDuration.text = movie.genre + "/" + String(movie.duration)
        self.reservation_rate.text = "\(movie.reservationRate)"
        self.user_rating.text = "\(movie.userRating)"
        self.audience.text = "\(movie.audience)"
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
