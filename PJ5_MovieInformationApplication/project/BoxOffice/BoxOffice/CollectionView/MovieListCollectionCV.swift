//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/30.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieListCollectionCV: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView?
    let cellIdentifier = "collectionViewCell"
    var arrayMovies: [Movies] = []
    
    let movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 데이타소스, 딜리게이트 선언
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        // 네비게이션바 옵션 설정
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        // 컬렉션뷰셀 레이아웃 초기설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        self.collectionView?.collectionViewLayout = layout
        
        self.movieService.getJsonFromUrlWithFilter(filterType: .reservationRate) { movies in DispatchQueue.main.async {
            self.arrayMovies = movies
            self.collectionView?.reloadData()
            }
        }
    }
    
    
    // MARK: - view life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            if let movieListTableCV = navigationController.viewControllers.first as? MovieListTableVC {
                movieListTableCV.arrayMovies = self.arrayMovies
                movieListTableCV.navigationItem.title = self.navigationItem.title
            }
        }
    }
    
    // 네비게이션바 아이템 액션: 데이터 정렬 방식 설정
    @IBAction func navigationItemAction(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
    }
    
    func showAlertController (style: UIAlertController.Style) {
        
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let reservationServiceType: filteringMethod = .reservationRate
        let reservationRateAction: UIAlertAction
        reservationRateAction = UIAlertAction(title: reservationServiceType.title, style: UIAlertAction.Style.default) { _ in self.movieService.getJsonFromUrlWithFilter(filterType: reservationServiceType) { movies in
            DispatchQueue.main.async {
                self.navigationItem.title = reservationServiceType.title
                self.arrayMovies = movies
                self.collectionView?.reloadData()
            }
            }
        }
        
        let qurationServiceType: filteringMethod = .quration
        let qurationAction: UIAlertAction
        qurationAction = UIAlertAction(title: qurationServiceType.title , style: UIAlertAction.Style.default) { _ in
            self.movieService.getJsonFromUrlWithFilter(filterType: qurationServiceType) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = qurationServiceType.title
                    self.arrayMovies = movies
                    self.collectionView?.reloadData()
                }
            }
        }
        
        let openDayServiceType: filteringMethod = .open
        let openDayAction: UIAlertAction
        openDayAction = UIAlertAction(title: openDayServiceType.title, style: UIAlertAction.Style.default) { _ in self.movieService.getJsonFromUrlWithFilter(filterType: openDayServiceType) { movies in
            DispatchQueue.main.async {
                self.navigationItem.title = openDayServiceType.title
                self.arrayMovies = movies
                self.collectionView?.reloadData()
            }
            }
        }
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in print("취소버튼 선택")})
        
        alertController.addAction(reservationRateAction)
        alertController.addAction(qurationAction)
        alertController.addAction(openDayAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: { print("Alert controller shown")})
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListCollectionCV: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsVC {
            movieDetailsVC.viewControllerTitle = self.arrayMovies[indexPath.row].title
            movieDetailsVC.movieId = self.arrayMovies[indexPath.row].id
            movieDetailsVC.gradeOfMovie = self.arrayMovies[indexPath.row].grade
            
            self.navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MovieListCollectionCV: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:MovieListCollectionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieListCollectionCVC else {
            return UICollectionViewCell()
        }
        
        let movie: Movies = self.arrayMovies[indexPath.row]
        cell.movieImageView?.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: movie.thumb) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                
                if let index: IndexPath = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        
                        cell.movieImageView?.image = UIImage(data: imageData)
                        
                        let valueOfGrade: Int = movie.grade
                        
                        switch valueOfGrade {
                        case 0: cell.gradeImageView?.image = UIImage(named: "ic_allages")
                        case 12: cell.gradeImageView?.image = UIImage(named: "ic_12")
                        case 15: cell.gradeImageView?.image = UIImage(named: "ic_15")
                        case 19: cell.gradeImageView?.image = UIImage(named: "ic_19")
                        default: cell.gradeImageView?.image = nil
                        }
                    }
                }
            }
        }
        if cell.movieTitleLabel?.adjustsFontSizeToFitWidth == false {
            cell.movieTitleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        cell.movieTitleLabel?.text = movie.title
        cell.gradeAndRateLabel?.text = movie.collectionReservationGrade + movie.collectionUserRating + " / " + movie.collectionReservationRate
        cell.openDateLabel?.text = movie.collectionOpenDate
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListCollectionCV: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSizeX: CGFloat = collectionView.frame.width / 2 - 1
        
        return CGSize(width: targetSizeX, height: 2 * targetSizeX)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


