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
    }
}

extension PracticeViewController2: SliderView2Delegate {
    func slider2(didvaluechange value: Int?) {
        print("")
    }
}

protocol SliderView2Delegate: AnyObject {
    func slider2(didvaluechange value: Int?)
}

// 클래스를 만들고 그 클래스 안에서 딜리게이트 함수를 만들어준다.
class SliderView2: UIView {
    
    weak var delegate: SliderView2Delegate?
    
    var value: Int?
    
    func valueChange() {
        self.delegate?.slider2(didvaluechange: self.value)
    }
}
