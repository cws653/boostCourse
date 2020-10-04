//
//  MakeCommentsVC.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/13.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MakeCommentsVC: UIViewController {
    
    @IBOutlet weak var labelOfTitle: UILabel?
    @IBOutlet weak var imageOfGrade: UIImageView?
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var gradeOfLabel: UILabel?
    @IBOutlet weak var sliderOfGrade: UISlider?
    @IBOutlet weak var userIdTextField: UITextField?
    @IBOutlet weak var firstStar: UIImageView?
    @IBOutlet weak var secondStar: UIImageView?
    @IBOutlet weak var thirdStar: UIImageView?
    @IBOutlet weak var fourthStar: UIImageView?
    @IBOutlet weak var fifthStar: UIImageView?
    
    var gradeOfMovie: Int?
    var titleOfMovie: String?
    var urlId: String?
    let userInfo = UserDefaults.standard
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var userId = userInfo.string(forKey: "userId")
        self.userIdTextField?.text = userId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentsTextView.layer.borderWidth = 2.0
        self.contentsTextView.layer.borderColor = UIColor.systemOrange.cgColor
        
        self.title = "한줄평 작성"
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        let finishButton = UIBarButtonItem.init(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(testSource(sender:)))
        self.navigationItem.rightBarButtonItem = finishButton
        
        let backButton = UIBarButtonItem.init(title: "취소", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.contentsTextView?.text = "내용을 입력해주세요."
        self.contentsTextView?.textColor = UIColor.systemGray4
        
        self.labelOfTitle?.text = titleOfMovie
        
        switch gradeOfMovie  {
        case 0: imageOfGrade?.image = UIImage(named: "ic_allages")
        case 12: imageOfGrade?.image = UIImage(named: "ic_12")
        case 15: imageOfGrade?.image = UIImage(named: "ic_15")
        case 19: imageOfGrade?.image = UIImage(named: "ic_19")
        default: imageOfGrade?.image = nil
        }
    }
    
    private func isValidCheckButton() -> Bool {
        guard
            let userRate = gradeOfLabel?.text, !userRate.isEmpty,
            let userId = userIdTextField?.text, !userId.isEmpty,
            let contents = contentsTextView.text, !contents.isEmpty
            else {
                return false
        }
        return true
    }
    
    @objc func testSource(sender: UIBarButtonItem) {
        if self.isValidCheckButton() {
            self.userInfo.set(userIdTextField?.text, forKey: "userId")
            post()
        } else {
            let alertController = UIAlertController(title: "경고", message: "내용을 입력해주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    struct EndocdePOST: Codable {
        var rating: Int
        var writer: String
        var movie_id: String
        var contents: String
    }
    
    struct DecodPost: Decodable {
        var rating: Double
        var timestamp: Double
        var writer: String
        var movie_id: String
        var contents: String
    }
    
    func post() {
        let rating: Int = Int(self.gradeOfLabel?.text ?? "0") ?? 0
        let writer = self.userIdTextField?.text ?? ""
        let movie_id = self.urlId ?? ""
        let contents = self.contentsTextView.text ?? ""
        
        let newPOST = EndocdePOST(rating: rating, writer: writer, movie_id: movie_id, contents: contents)
        do {
            let newPostData = try JSONEncoder().encode(newPOST)
            
            //let paramData = param.data(using: .utf8)
            
            let url = URL(string: "http://connect-boxoffice.run.goorm.io/comment")
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = newPostData
            
            let dataTask: URLSessionTask = URLSession.shared.dataTask(with: request) {(datas, response, error) in
                if error != nil {
                    print("Network Error")
                }
                
                do {
                    if let data = datas {
                        let parsed = try JSONDecoder().decode(DecodPost.self, from: data)
                        print("parsed \(parsed)")
                        
                        DispatchQueue.main.async {
                            let secondVC = self.navigationController?.viewControllers.filter { $0 is MovieDetailsVC }
                            
                            if let realSecondVC = secondVC?.first as? MovieDetailsVC {
//                                realSecondVC.parsed = parsed
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                } catch {
                    print("Error")
                }
            }
            dataTask.resume()
            
        } catch {
            
        }
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        switch round(sender.value) {
        case 0:
            firstStar?.image = UIImage(named: "ic_star_large")
            secondStar?.image = UIImage(named: "ic_star_large")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 1.0:
            firstStar?.image = UIImage(named: "ic_star_large_half")
            secondStar?.image = UIImage(named: "ic_star_large")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 2.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 3.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_half")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 4.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 5.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_half")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 6.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 7.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_half")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 8.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_full")
            fifthStar?.image = UIImage(named: "ic_star_large")
        case 9.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_full")
            fifthStar?.image = UIImage(named: "ic_star_large_half")
        case 10.0:
            firstStar?.image = UIImage(named: "ic_star_large_full")
            secondStar?.image = UIImage(named: "ic_star_large_full")
            thirdStar?.image = UIImage(named: "ic_star_large_full")
            fourthStar?.image = UIImage(named: "ic_star_large_full")
            fifthStar?.image = UIImage(named: "ic_star_large_full")
        default:
            break
        }
        self.gradeOfLabel?.text = String(Int(round(sender.value)))
        if sender.isTracking { return }
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


// MARK: - UITableViewDelegate
extension MakeCommentsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 5
        } else {
            return 0
        }
    }
}




extension MakeCommentsVC: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if contentsTextView.textColor == UIColor.systemGray4 {
            let startPosition = contentsTextView.beginningOfDocument
            contentsTextView.selectedTextRange = contentsTextView.textRange(from: startPosition, to: startPosition)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentsTextView.text.isEmpty {
            contentsTextView.text = "내용 입력하세요."
            contentsTextView.textColor = UIColor.systemGray4
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if contentsTextView.textColor == UIColor.systemGray4 {
            contentsTextView.text = nil
            contentsTextView.textColor = UIColor.black
        }
    }
}
