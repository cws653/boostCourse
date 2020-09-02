//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/30.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView?
    let cellIdentifier = "collectionViewCell"
    var arryMovies: [Movies] = []
    var targetSizeX: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 데이타소스, 딜리게이트 선언
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        // 네비게이션바 옵션 설정
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // 컬렉션뷰셀 레이아웃 초기설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        self.collectionView?.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url: URL = URL(string:
            "https://connect-boxoffice.run.goorm.io/movies?order_type=1") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.arryMovies = apiResponse.movies
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            } catch(let err) {
                print(err.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    // 네비게이션바 아이템 액션: 데이터 정렬 방식 설정
    @IBAction func navigationItemAction(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
    }
    
    func showAlertController (style: UIAlertController.Style) {
        
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let reservationRateAction: UIAlertAction
        reservationRateAction = UIAlertAction(title: "예매율", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("예매율 선택") })
        
        let curationAction: UIAlertAction
        curationAction = UIAlertAction(title: "큐레이션" , style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in print("큐레이션 선택")})
        
        let openDayAction: UIAlertAction
        openDayAction = UIAlertAction(title: "개봉일", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction) in print("개봉일 선택")})
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in print("취소버튼 선택")})
        
        alertController.addAction(reservationRateAction)
        alertController.addAction(curationAction)
        alertController.addAction(openDayAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: { print("Alert controller shown")})
    }
    
    // 데이터소스 내용
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arryMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie: Movies = self.arryMovies[indexPath.row]
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
                        case 0:
                            cell.gradeImageView?.image = UIImage(named: "ic_allages")
                        case 12:
                            cell.gradeImageView?.image = UIImage(named: "ic_12")
                        case 15:
                            cell.gradeImageView?.image = UIImage(named: "ic_15")
                        case 19:
                            cell.gradeImageView?.image = UIImage(named: "ic_19")
                        default:
                            cell.gradeImageView?.image = nil
                        }
                    }
                }
            }
        }
        
        cell.firstLabel?.text = movie.title
        cell.secondLabel?.text = movie.collectionReservationGrade + movie.collectionUserRating + " / " + movie.collectionReservationRate
        cell.thirdLabel?.text = movie.collectionDate
        
        return cell
    }
    
    // 셀의 크기를 delegateFlowLayout 으로 만들어준다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        targetSizeX = collectionView.frame.width / 2 - 1
        
        return CGSize(width: targetSizeX, height: 2 * targetSizeX)
    }
    
    // 4. cell 내부 아이템의 최소 스페이싱을 설정한다. 셀간의 가로 간격이라고 생각하면 된다.
    // 자세한 내용은 애플문서나 부스트코스를 보자.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 5. cell 간 라인 스페이싱을 설정한다. 셀간의 세로 간격이라고 생각하면 된다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
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
