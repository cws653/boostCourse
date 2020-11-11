//
//  ViewController.swift
//  AsyncExample
//
//  Created by 최원석 on 2020/08/04.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func touchUpDownloadButton(_ sender: UIButton) {
        // 이미지 다운로드 -> 이미지 뷰에 셋팅
        
        // https://www.travelweek.ca/wp-content/uploads/2019/01/Explore-the-Islands-with-Hawai%E2%80%98i-Tourism-Canada.jpg
        
        let imageURL: URL = URL(string: "https://www.travelweek.ca/wp-content/uploads/2019/01/Explore-the-Islands-with-Hawai%E2%80%98i-Tourism-Canada.jpg")!
        
        OperationQueue().addOperation {
            let imageData: Data = try! Data.init(contentsOf: imageURL)
            let image: UIImage = UIImage(data: imageData)!
            
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

