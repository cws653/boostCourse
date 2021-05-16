//
//  MakeCommentsVC.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/13.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MakeCommentsViewController: UIViewController {

    private let movieServiceProvider = MovieServiceProvider.shared
    private let userInfo = UserDefaults.standard
    var movies: Movies?

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

    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "한줄평 작성"
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let finishButton = UIBarButtonItem.init(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(loadingComments(sender:)))
        self.navigationItem.rightBarButtonItem = finishButton
        
        let backButton = UIBarButtonItem.init(title: "취소", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        self.contentsTextView.layer.borderWidth = 2.0
        self.contentsTextView.layer.borderColor = UIColor.systemOrange.cgColor
        self.contentsTextView.text = "내용을 입력해주세요."
        self.contentsTextView.textColor = UIColor.systemGray4
        
        let startPosition = contentsTextView.beginningOfDocument
        contentsTextView.selectedTextRange = contentsTextView.textRange(from: startPosition, to: startPosition)
        
        self.labelOfTitle?.text = movies?.title
        
        switch movies?.grade  {
        case 0: imageOfGrade?.image = UIImage(named: "ic_allages")
        case 12: imageOfGrade?.image = UIImage(named: "ic_12")
        case 15: imageOfGrade?.image = UIImage(named: "ic_15")
        case 19: imageOfGrade?.image = UIImage(named: "ic_19")
        default: imageOfGrade?.image = nil
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = userInfo.string(forKey: "userId")
        self.userIdTextField?.text = userId
    }
    
    @objc func loadingComments(sender: UIBarButtonItem) {
        if self.isValidCheckButton() {
            self.userInfo.set(userIdTextField?.text, forKey: "userId")

            guard let rating = Int(self.gradeOfLabel?.text ?? "0") else { return }
            guard let writer = self.userIdTextField?.text else { return }
            guard let movie_id = self.movies?.id else { return }
            guard let contents = self.contentsTextView.text else { return }

            let postCommentData = PostComment(rating: rating, writer: writer, movie_id: movie_id, contents: contents)
            movieServiceProvider.postComment(postComment: postCommentData) {
                DispatchQueue.main.async {
                    if let movieDetailsViewController = self.navigationController?.viewControllers.filter({ $0 is MovieDetailsViewController }) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "경고", message: "내용을 입력해주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
}


// MARK: - UITableViewDelegate
extension MakeCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 5
        } else {
            return 0
        }
    }
}

// MARK: - UITextViewDelegate
extension MakeCommentsViewController: UITextViewDelegate {
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

