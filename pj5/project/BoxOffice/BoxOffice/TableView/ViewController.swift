//
//  ViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

enum ServiceType: Int {
    case reservation = 0
    case quration = 1
    case openDay = 2
    
    var title: String {
        switch self {
        case .reservation:
            return "예매율"
        case .quration:
            return "큐레이션"
        case .openDay:
            return "개봉일"
        }
    }
}

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView?
    let cellIdentifier: String = "tableViewCell"
    var arryMovies: [Movies] = []
    
    let movieService = MovieService()
    
    // MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 네비게이션바 옵션 설정
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.tabBarController?.delegate = self
        
        self.movieService.requestMovies(urlInt: nil) { movies in
            DispatchQueue.main.async {
                self.arryMovies = movies
                self.tableView?.reloadData()
            }
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.didReceieveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
    }
    
//    @objc func didReceieveMoviesNotification(_ noti: Notification) {
//
//        guard let movies: [Movies] = noti.userInfo?["movies"] as? [Movies] else { return }
//
//        self.arryMovies = movies
//
//        DispatchQueue.main.async {
//            self.tableView?.reloadData()
//        }
//
//    }
    
    // MARK: -viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //requestMovies(urlInt: nil)
    }
    
    // 네비게이션바 아이템 액션: 데이터 정렬 방식 설정
    @IBAction func navigationItemAction(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
    }
    
    //    func funcOfSortData() {
    //        self.arryMovies = self.arryMovies.sorted(by: { $0.reservationGrade < $1.reservationGrade })
    //    }
    
    //    self.sortArrayMovies = self.arryMovies.sorted(by: {$0.reservationGrade < $1.reservationGrade})}
    
    func showAlertController (style: UIAlertController.Style) {
        
    
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let reservationServiceType: ServiceType = .reservation
        let reservationRateAction: UIAlertAction
        reservationRateAction = UIAlertAction(title: reservationServiceType.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.requestMovies(urlInt: reservationServiceType.rawValue) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = "예매율"
                    self.arryMovies = movies
                    self.tableView?.reloadData()
                }
            }
        }
        
        //reservationRateAction = UIAlertAction(title: "예매율", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in requestMovies(urlInt: 0)})
        // 여기서 버튼을 클릭하면 배열이 정렬되도록 만들어주는 클로저함수를 만들어야 한다. 근데 그게 안된다.
        
        let curationAction: UIAlertAction
        curationAction = UIAlertAction(title: ServiceType.quration.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.requestMovies(urlInt: ServiceType.quration.rawValue) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = "큐레이션"
                    self.arryMovies = movies
                    self.tableView?.reloadData()
                }
            }
        }
        
        let openDayAction: UIAlertAction
        openDayAction = UIAlertAction(title: ServiceType.openDay.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.requestMovies(urlInt: ServiceType.openDay.rawValue) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = "개봉일"
                    self.arryMovies = movies
                    self.tableView?.reloadData()
                }
            }
        }
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in print("취소버튼 선택")})
        
        alertController.addAction(reservationRateAction)
        alertController.addAction(curationAction)
        alertController.addAction(openDayAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: { print("Alert controller shown")})
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let nextViewController: SecondTableViewController = segue.destination as? SecondTableViewController else {
            return
        }
        
        guard let cell: CustomTableViewCell = sender as? CustomTableViewCell else {
            return
        }
        
        nextViewController.textToSetTitle = cell.customLabel1?.text
    }
}

// MARK: - UITableViewDelegeate
extension ViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let movie: Movies = self.arryMovies[indexPath.row]
        cell.customImageView1?.image = nil
        
        // 등급을 나타내는 이미지를 넣어줘야한다. 해당 이미지를 넣기 위해서는 조건문을 사용해야한다. 데이터는 인트값으로 넘어오므로 해당 인트일 경우 이미지 무엇을 사용하겠다는 식으로 소스를 짜야한다.
        
        guard let imageURL: URL = URL(string: movie.thumb) else {
            return UITableViewCell()
        }
        
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
//                if let index: IndexPath = tableView.indexPath(for: cell) {
//                    if index.row == indexPath.row {
                        
                cell.customImageView1?.image = UIImage(data: data)
                
                let valueOfGrade: Int = movie.grade
                
                switch valueOfGrade {
                case 0:
                    cell.customImageView2?.image = UIImage(named: "ic_allages")
                case 12:
                    cell.customImageView2?.image = UIImage(named: "ic_12")
                case 15:
                    cell.customImageView2?.image = UIImage(named: "ic_15")
                case 19:
                    cell.customImageView2?.image = UIImage(named: "ic_19")
                default:
                    cell.customImageView2?.image = nil
                }
//                    }
//                }
                
                cell.customLabel1?.text = movie.title
                cell.customLabel2?.text = movie.tableUserRating + " " + movie.tableReservationGrade + " " + movie.tableReservationRate
                cell.customLabel3?.text = movie.tableDate
            }
        }.resume()
                
        return cell
    }
}

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let navigationController = viewController as? UINavigationController {
            if let collectionViewController = navigationController.viewControllers.first as? CollectionViewController {
                collectionViewController.arryMovies = self.arryMovies
            }
        }
    }
}


