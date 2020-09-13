//
//  SecondTableViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/01.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class SecondTableViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView?
    
    
    private var arryDetailMovies:[DetailContents] = []
    var comments: [Comment] = []
    
    var textToSetTitle: String?
    
    private let movieService = MovieService()
    var urlId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 네비게이션바 설정 소스
        self.title = textToSetTitle
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        guard let urlId = urlId else {
            return
        }
        
        self.movieService.getJsonFromUrlMovieDetail(movieId: urlId) { movies in
            DispatchQueue.main.async {
                self.arryDetailMovies = movies
                self.tableView?.reloadData()
            }
        }
        
        self.movieService.getJsonFromUrlWithMoiveId(movieId: urlId) { commenList in
            DispatchQueue.main.async {
                self.comments = commenList?.comments ?? []
                self.tableView?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let showVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieFullImageVC") as! MovieFullImageVC
        self.present(showVC, animated: false) {
            showVC.fullScreen.image = tappedImage.image
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SecondTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240.0
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
}


// MARK: - UITableViewDelegate
extension SecondTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else {
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId") as! DetailViewPosterCell
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            
            cell.imageOfMovie.isUserInteractionEnabled = true
            cell.imageOfMovie.addGestureRecognizer(tapGestureRecognizer)
            
            var movie: DetailContents
            if self.arryDetailMovies.isEmpty {
                return .init()
            } else {
                if self.arryDetailMovies.count > indexPath.row {
                    movie = self.arryDetailMovies[indexPath.row]
                } else {
                    return .init()
                }
            }
            
            cell.setUI(with: movie)
            
            return cell
        } else if indexPath.section == 1{
            let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId1") as! DetailViewContentsCell
            
            var movie: DetailContents
            if self.arryDetailMovies.isEmpty {
                return .init()
            } else {
                if self.arryDetailMovies.count > indexPath.row {
                    movie = self.arryDetailMovies[indexPath.row]
                } else {
                    return .init()
                }
            }
            
            cell.setUI(with: movie)
            return cell
        } else {
            let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId2") as! DetailViewCommentCell
            
            let comment: Comment = self.comments[indexPath.row]
            
            cell.setUI(with: comment)
            
            return cell
        }
        
    }
}



