//
//  ViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

enum filteringMethod:Int {
    case reservationRate = 0
    case quration = 1
    case open = 2
    
    var title: String {
        switch self {
        case .reservationRate: return "예매율"
        case .quration: return "큐레이션"
        case .open: return "개봉일"
        }
    }
}

class MovieListTableVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView?
    let cellIdentifier: String = "tableViewCell"
    var arryMovies: [Movies] = []
    
    // movie 내용을 보여주는데 필요한 기능을 별도의 클래스로 묶었다.
    let movieService = MovieService()
    
    // MARK: - 뷰 상태변화
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 네비게이션바 옵션 설정
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        
        self.movieService.getJsonFromUrlWithFilter(filterType: .reservationRate) { movies in DispatchQueue.main.async {
            self.arryMovies = movies
            self.tableView?.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView?.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let navigationController = self.tabBarController?.viewControllers?[1] as? UINavigationController {
            if let movieListCollectionCV = navigationController.viewControllers.first as? MovieListCollectionCV {
                movieListCollectionCV.arryMovies = self.arryMovies
                movieListCollectionCV.navigationItem.title = self.navigationItem.title
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
        reservationRateAction = UIAlertAction(title: reservationServiceType.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.getJsonFromUrlWithFilter(filterType: reservationServiceType) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = reservationServiceType.title
                    self.arryMovies = movies
                    self.tableView?.reloadData()
                }
            }
        }
        
        let qurationServiceType: filteringMethod = .quration
        let qurationAction: UIAlertAction
        qurationAction = UIAlertAction(title: qurationServiceType.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.getJsonFromUrlWithFilter(filterType: qurationServiceType) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = qurationServiceType.title
                    self.arryMovies = movies
                    self.tableView?.reloadData()
                }
            }
        }
        
        let openDayServiceType: filteringMethod = .open
        let openDayAction: UIAlertAction
        openDayAction = UIAlertAction(title: openDayServiceType.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.getJsonFromUrlWithFilter(filterType: openDayServiceType) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = openDayServiceType.title
                    self.arryMovies = movies
                    self.tableView?.reloadData()
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

// MARK: - UITableViewDelegeate
extension MovieListTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondTableViewController = storyboard.instantiateViewController(withIdentifier: "SecondTableViewController") as? MovieDetailsVC {
            secondTableViewController.textToSetTitle = self.arryMovies[indexPath.row].title
            secondTableViewController.urlId = self.arryMovies[indexPath.row].id
            secondTableViewController.gradeOfMovie = self.arryMovies[indexPath.row].grade
            
            //self.present(secondTableViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(secondTableViewController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieListTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: MovieListTableCVC = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MovieListTableCVC else {
            return UITableViewCell()
        }
        
        let movie: Movies = self.arryMovies[indexPath.row]
        cell.thumbImageView?.image = nil
        
        guard let imageURL: URL = URL(string: movie.thumb) else {
            return UITableViewCell()
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                cell.thumbImageView?.image = UIImage(data: data)
                
                let valueOfGrade: Int = movie.grade
                
                switch valueOfGrade {
                case 0: cell.gradeImageView?.image = UIImage(named: "ic_allages")
                case 12: cell.gradeImageView?.image = UIImage(named: "ic_12")
                case 15: cell.gradeImageView?.image = UIImage(named: "ic_15")
                case 19: cell.gradeImageView?.image = UIImage(named: "ic_19")
                default: cell.gradeImageView?.image = nil
                }
                
                cell.titleLabel?.text = movie.title
                cell.rateLabel?.text = movie.tableUserRating + " " + movie.tableReservationGrade + " " + movie.tableReservationRate
                cell.openDateLabel?.text = movie.tableDate
            }
        }.resume()
        
        return cell
    }
}





