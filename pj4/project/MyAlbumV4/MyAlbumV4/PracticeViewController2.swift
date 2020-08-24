//
//  PracticeViewController2.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/23.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class PracticeViewController2: UIViewController {

    var sliderView2 = SliderView2()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sliderView2.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension PracticeViewController2: sliderView2Delegate {
    func sliderView2(didchangeValue: Int?) {
        print("슬라이더뷰에서 값이 바뀐상태를 didChangeValue를 통해 받아온다. \(didchangeValue)")
    }
}

protocol sliderView2Delegate: AnyObject {
    func sliderView2(didchangeValue: Int?)
    
}

class SliderView2: UIView {
    
    weak var delegate: sliderView2Delegate?
    
    var value: Int?
    
    func valueChanged() {
        //value값이 바뀌어버림.
        self.delegate?.sliderView2(didchangeValue: self.value)
    }
    
}
