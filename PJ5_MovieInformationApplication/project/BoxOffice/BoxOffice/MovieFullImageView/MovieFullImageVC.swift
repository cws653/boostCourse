//
//  MovieFullImageVC.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/13.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieFullImageVC: UIViewController {

    @IBOutlet var fullScreen: UIImageView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         let tap = UITapGestureRecognizer()
         tap.addTarget(self, action: #selector(tapScreen(_:)))
         
         fullScreen.isUserInteractionEnabled = true
         fullScreen.addGestureRecognizer(tap)
         
         self.navigationController?.navigationBar.isHidden = true
     }
    
     override var prefersStatusBarHidden: Bool {
         return true
     }
     
     // MARK:- TapScreen
     @objc func tapScreen(_ sender: UITapGestureRecognizer) {
         dismiss(animated: true, completion: nil)
     }
}
