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
//    var returnOfAssetCountry: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // 네비게이션바 설정 소스
        self.navigationController?.navigationBar.barTintColor = .blue
//        self.title = "세계 날씨"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
        
        
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
    
    // 테이블뷰 섹션별 행의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    // 테이블뷰 셀마다 넣어줄 데이터소스를 물어보는 함수
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        // indexpath는 데이터 경로 또는 위치를 의미한다.
        // 그 안에 섹션, 행, 열 값이 포함되어있다.
        
        let country: Country = self.countries[indexPath.row]
        
        cell.textLabel?.text = country.koreanName
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
//        returnOfAssetCountry = country.assetName
        
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
    //
    //  In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //  Get the new view controller using segue.destination.
        //  Pass the selected object to the new view controller.
        
        guard let nextViewController: SecondViewController = segue.destination as? SecondViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        
        nextViewController.textToSetTitle = cell.textLabel?.text
        
//        nextViewController.assetOfCountry = returnOfAssetCountry
    }
}

