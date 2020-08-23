//
//  ViewController.swift
//  pj1_v3
//
//  Created by 최원석 on 2020/07/18.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    // MARK: - Properties
    // 클래스 객체를 생성한 것
    var player : AVAudioPlayer! //
    var timer: Timer!
    
    // Mark: IBOutlets
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    // 프로그램 실행전에 메모리에 저장해주는 값들을 말한다.
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializePlayer()
    }
    
    // MARK: - Methods
    // MARK: Custom Method
    
    // initializePlayer 함수 생성
    func initializePlayer() {
        
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            return // return 값은 break 와 같은 값을 가진다고 생각하면 된다.
        }
        // soundAsset 변수에 "sound" 이름의 데이터를 담아준다.
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        // 에러를 잡아주는 소스이다.
        // self.player 변수에 AVAudioPlayer(soundAsset 데이터 를 받음) 를 담아주고 에러테스트를 해준다.
        
        self.progressSlider.maximumValue =  Float(self.player.duration)
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = Float(self.player.currentTime)
        // progressSlider 의 max, min, curent value 값을 설정해준다.
    }
    // initializePlayer 를 이용하여 sound 데이터를 로딩하고 그것이 제대로 로딩이 되었는지 확인하였다.
    // 또한 player 변수에 data 닶을 넣어놓고 그 data값의 변화에 따라 slider의 값이 변할 수 있도록 slider 변수값을 설정해놓았다.
    
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.timeLabel.text = timeText
    }
    // 위 함수를 통해 textLabel 에 time값을 표시할 수 있도록 했다.
    // minute, second, milisecond 3개로 이루어줘 label 값을 표시하도록 해놨다.
    
    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    // 이 함수가 명확하게 이해가 안간다. 그러나 timer 값을 설정하고 이것을 이용해서 textLabel, Slider 을 조정하는 것 같다.
    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    
    // MARK: IBActions
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
        } else {
            self.player?.pause()
        }
        // 버튼이 클릭되어 있으면 play 하고, 버튼이 클릭되어있지 않으면 puase 가 된다.
        
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
        // 버튼이 클릭되어 있으면 makeAndFireTimer() 실행, 버튼이 클릭되어있지 않으면 invaludateTimer() 실행
        
    }
    // button 을 선택했을 때 일어나는 이벤트를 관리해주는 함수이다. 디테일한 내용은 안에 설명해놓자.
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    }
    // slider 가 움직일 때 함수를 말한다. 여기서 이해안가는 것은 if sender.isTracking { return }이다. 왜 구지 썼는지 이해가 안간다.
    
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
    

}

