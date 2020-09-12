//
//  SecondTableViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/01.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class SecondTableViewController: UIViewController {
    
    var urlId: String?
    var textToSetTitle: String?
    @IBOutlet weak var uiView1: UIView?
    @IBOutlet weak var textLabel: UILabel?
    var arryDetailMovies:[DetailContents] = []
    let movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 네비게이션바 설정 소스
        self.title = textToSetTitle
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // textLabel 설정
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.numberOfLines = 0
        
        // 뷰컨트롤러에 상세내용 올리기
        self.movieService.requestDetailContents(urlId: self.urlId) { movies2 in DispatchQueue.main.async {
            self.arryDetailMovies = movies2
            
            }
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
