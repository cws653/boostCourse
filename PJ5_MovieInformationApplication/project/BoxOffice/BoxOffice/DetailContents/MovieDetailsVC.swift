//
//  SecondTableViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/01.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView?
    
    private var arrayDetailMovies:[DetailContents] = []
    var comments: [Comment] = []
    
    var viewControllerTitle: String?
    var gradeOfMovie: Int?
    var movieId: String?
    
    private let movieService = MovieService()
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션바 설정 소스
        self.title = viewControllerTitle
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let movieId = movieId else {
            return
        }
        
        self.movieService.getJsonFromUrlMovieDetail(movieId: movieId) { movies in
            DispatchQueue.main.async {
                self.arrayDetailMovies = movies
                self.tableView?.reloadData()
            }
        }
        
        self.movieService.getJsonFromUrlWithMoiveId(movieId: movieId) { commenList in
            DispatchQueue.main.async {
                self.comments = commenList?.comments ?? []
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let tappedImage = tapGestureRecognizer.view as? UIImageView else {
            return
        }
        
        guard let showVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieFullImageVC") as? MovieFullImageVC  else {
            return
        }
        
        self.present(showVC, animated: false) {
            showVC.fullScreen.image = tappedImage.image
        }
    }
    
    @objc func touchUpCommentsBtn(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let makeCommentsVC = storyBoard.instantiateViewController(withIdentifier: "MakeCommentsVC" ) as? MakeCommentsVC {
            makeCommentsVC.viewControllerTitle = self.viewControllerTitle
            makeCommentsVC.gradeOfMovie = self.gradeOfMovie
            makeCommentsVC.movieId = self.movieId
            
            self.navigationController?.pushViewController(makeCommentsVC, animated: true)
        }
    }
}


// MARK: - UITableViewDelegate
extension MovieDetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 0 || section == 1 || section == 2 else { return 0 }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 3 else { return nil }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 50))
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        label.text = "한줄평"
        view.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: tableView.frame.size.width - 30, y: 0, width: 30, height: 30))
        button.backgroundColor = .white
        button.setImage(UIImage(named: "btn_compose"), for: .normal)
        button.addTarget(self, action: #selector(touchUpCommentsBtn(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }
}


// MARK: - UITableViewDataSource
extension MovieDetailsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 {
            return 1
        } else {
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId") as? DetailViewPosterCell  else {
                return UITableViewCell()
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            
            cell.imageOfMovie.isUserInteractionEnabled = true
            cell.imageOfMovie.addGestureRecognizer(tapGestureRecognizer)
            
            var movie: DetailContents
            if self.arrayDetailMovies.isEmpty {
                return .init()
            } else {
                if self.arrayDetailMovies.count > indexPath.row {
                    movie = self.arrayDetailMovies[indexPath.row]
                } else {
                    return .init()
                }
            }
            cell.setUI(with: movie)
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId1") as? DetailViewContentsCell  else {
                return UITableViewCell()
            }
            
            var movie: DetailContents
            if self.arrayDetailMovies.isEmpty {
                return .init()
            } else {
                if self.arrayDetailMovies.count > indexPath.row {
                    movie = self.arrayDetailMovies[indexPath.row]
                } else {
                    return .init()
                }
            }
            cell.setUI(with: movie)
            return cell
            
        } else if indexPath.section == 2 {
            guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId2") as? DetailViewCastCell  else {
                return UITableViewCell()
            }
            
            var movie: DetailContents
            if self.arrayDetailMovies.isEmpty {
                return .init()
            } else {
                if self.arrayDetailMovies.count > indexPath.row {
                    movie = self.arrayDetailMovies[indexPath.row]
                } else {
                    return .init()
                }
            }
            cell.setUI(with: movie)
            return cell
            
        }
        else {
            guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cellId3") as? DetailViewCommentCell else {
                return UITableViewCell()
            }
            
            let comment: Comment = self.comments[indexPath.row]
            cell.setUI(with: comment)
            return cell
        }
    }
}



