//
//  DelegatePractice.swift
//  MyAlbumV4
//
//  Created by 최원석 on 2020/08/23.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController {
    
    private var sliderView = SliderView()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.sliderView.delegate = self
        
    }
}

extension PracticeViewController: SliderViewDelegate {
    func sliderView(vlaueDidChange value: Int?) {
        print("vlaue 값 얻어서 뭐하면됨.")
    }
}




protocol SliderViewDelegate: AnyObject {
    func sliderView(vlaueDidChange value: Int?)
}

class SliderView: UIView {
    
    internal weak var delegate: SliderViewDelegate?
    
    private var value: Int?
    
    private func valueChanged() {
        self.delegate?.sliderView(vlaueDidChange: self.value)
    }
}
