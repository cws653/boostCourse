//
//  ViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

enum filteringMethod:Int {
    case reservation_rate = 0
    case quration = 1
    case open = 2
    
    var title: String {
        switch self {
        case .reservation_rate:
            return "예매율"
        case .quration:
            return "큐레이션"
        case .open:
            return "개봉일"
        }
    }
}

class ViewController: UIViewController{
    
    //    var delegate: SendDataDeleagate?
    
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
        
        self.tabBarController?.delegate = self
        
        self.movieService.getJsonFromUrlWithFilter(filterType: .reservation_rate) { movies in DispatchQueue.main.async {
            self.arryMovies = movies
            self.tableView?.reloadData()
            }
        }
        
//        self.movieService.requestMovies(urlInt: nil) { movies in
//            DispatchQueue.main.async {
//                self.arryMovies = movies
//                self.tableView?.reloadData()
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // 네비게이션바 아이템 액션: 데이터 정렬 방식 설정
    @IBAction func navigationItemAction(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
    }
    
    func showAlertController (style: UIAlertController.Style) {
        
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let reservationServiceType: filteringMethod = .reservation_rate
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
    
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//        guard let nextViewController: SecondTableViewController = segue.destination as? SecondTableViewController else {
//            return
//        }
//
//        guard let cell: CustomTableViewCell = sender as? CustomTableViewCell else {
//            return
//        }
//
//        nextViewController.textToSetTitle = cell.customLabel1?.text
//        nextViewController.urlId = self.sendUrl
//    }
}

// MARK: - UITableViewDelegeate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondTableViewController = storyboard.instantiateViewController(withIdentifier: "SecondTableViewController") as? SecondTableViewController {
            secondTableViewController.textToSetTitle = self.arryMovies[indexPath.row].title
            secondTableViewController.urlId = self.arryMovies[indexPath.row].id
            
            //self.present(secondTableViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(secondTableViewController, animated: true)
        }
        
        
//        guard let nextViewController: SecondTableViewController = segue.destination as? SecondTableViewController else {
//            return
//        }
//
//        guard let cell: CustomTableViewCell = sender as? CustomTableViewCell else {
//            return
//        }
//
//        nextViewController.textToSetTitle = cell.customLabel1?.text
//        nextViewController.urlId = self.sendUrl
    }
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
        print("탭바가 클릭되었습니다.")
        //        delegate?.sendData(data: self.arryMovies)
        
        if let navigationController = viewController as? UINavigationController {
            if let collectionViewController = navigationController.viewControllers.first as? CollectionViewController {
                collectionViewController.arryMovies = self.arryMovies
            }
        }
    }
}




