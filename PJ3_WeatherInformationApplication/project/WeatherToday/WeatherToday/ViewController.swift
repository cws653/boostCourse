//
//  ViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/07/28.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "cell"
    
    var countries: [Country] = []
    let flagimages = ["flag_kr","flag_de","flag_it","flag_us","flag_fr","flag_jp"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = .blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "countries") else {
            return
        }
        
        do {
            self.countries = try jsonDecoder.decode([Country].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let country: Country = self.countries[indexPath.row]
        
        cell.textLabel?.text = country.koreanName
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        switch country.assetName {
        case "kr":
            cell.imageView?.image = UIImage(named: flagimages[0])
        case "de":
            cell.imageView?.image = UIImage(named: flagimages[1])
        case "it":
            cell.imageView?.image = UIImage(named: flagimages[2])
        case "us":
            cell.imageView?.image = UIImage(named: flagimages[3])
        case "fr":
            cell.imageView?.image = UIImage(named: flagimages[4])
        case "jp":
            cell.imageView?.image = UIImage(named: flagimages[5])
        default:
            cell.imageView?.image = nil
        }
        return cell
    }
    
    
    //  MARK: - Navigation
    //  In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        guard let nextViewController: SecondViewController = segue.destination as? SecondViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        nextViewController.textToSetTitle = cell.textLabel?.text
    }
}

