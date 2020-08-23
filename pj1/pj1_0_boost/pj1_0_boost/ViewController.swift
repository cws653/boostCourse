//
//  ViewController.swift
//  pj1_0_boost
//
//  Created by 최원석 on 2020/07/05.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK:- Properties
    var player: AVAudioPlayer!
    var timer: Timer!
    
    // MARK: IBOutlet
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBAction func touchPlayButton(_ sender: UIButton) {
    
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
        } else {
            self.player?.pause()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        print("slider value changed")
    }
    
    // MARK : - Method
    
}

