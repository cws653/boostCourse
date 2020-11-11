//
//  ViewController.swift
//  Networking
//
//  Created by 최원석 on 2020/08/22.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "friendCell"
    var friends: [Friend] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let friend: Friend = self.friends[indexPath.row]
        
        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        cell.imageView?.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: friend.picture.thumbnail) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        
        return cell
    }
    
    @objc func didRecieveFriendsNotification(_ noti: Notification) {
        
        guard let friends: [Friend] = noti.userInfo?["friends"] as? [Friend] else { return }
        
        self.friends = friends
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveFriendsNotification(_:)), name: DidReceiveFirendsNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestFriends()
    }
    
}

