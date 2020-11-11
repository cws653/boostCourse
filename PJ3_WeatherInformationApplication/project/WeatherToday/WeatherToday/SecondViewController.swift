//
//  SecondViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/01.
//  Copyright © 2020 최원석. All rights reserved.


import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var secondTableView: UITableView!
    
    
    
    let cellIdentifier: String = "secondCell"
    var textToSetTitle: String?
    var stateOfWeather: Int?
//    var celsiusString: String?
//    var rainfallProbabilityString: String?

    
    var weathers: [Weather] = []
    let weatherimages = ["cloudy", "sunny","rainy","snowy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.secondTableView.delegate = self
        self.secondTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        // 네비게이션바 설정 소스
        self.navigationController?.navigationBar.barTintColor = .blue
        self.title = textToSetTitle
        self.navigationController?.navigationBar.tintColor = .white
        
        // json 데이터 디코딩
        let jsonDecoder: JSONDecoder = JSONDecoder()
        var dataAsset: NSDataAsset?
        
        if textToSetTitle == "한국" {
            dataAsset = NSDataAsset(name: "kr")
        } else if textToSetTitle == "독일" {
            dataAsset = NSDataAsset(name: "de")
        }  else if textToSetTitle == "이탈리아" {
            dataAsset = NSDataAsset(name: "it")
        } else if textToSetTitle == "미국" {
            dataAsset = NSDataAsset(name: "us")
        } else if textToSetTitle == "프랑스" {
            dataAsset = NSDataAsset(name: "fr")
        } else if textToSetTitle == "일본" {
            dataAsset = NSDataAsset(name: "jp")
        }
        
        do {
            self.weathers = try jsonDecoder.decode([Weather].self, from: dataAsset!.data)
        } catch {
            print(error)
        }
        
        self.secondTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomTableViewCell = secondTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        let weather: Weather = self.weathers[indexPath.row]
        
        cell.customFirstLabel.text = weather.city_name
        cell.customSecondLabel.text = weather.celsiusString
        cell.customThirdLabel.text = weather.rainfallProbabilityString
        cell.selectionStyle = .none
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        if weather.celsius < 10 {
            cell.customSecondLabel.textColor = .blue
        } else {
            cell.customSecondLabel.textColor = .black
        }
        
        if weather.rainfall_probability > 50 {
            cell.customThirdLabel.textColor = .orange
        } else {
            cell.customThirdLabel.textColor = .black
        }
        
//        cell.detailTextLabel?.numberOfLines = 0
//        cell.textLabel?.text = weather.city_name
//        cell.detailTextLabel?.text = weather.celsiusString + "\n" + weather.rainfallProbabilityString
//        cell.selectionStyle = .none
//        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//
//        if weather.celsius < 10 {
//            cell.detailTextLabel?.textColor = .orange
//        }
//
        
        switch weather.state {
        case 10:
            cell.customImageView.image = UIImage(named: weatherimages[1])
        case 11:
            cell.customImageView.image = UIImage(named: weatherimages[0])
        case 12:
            cell.customImageView.image = UIImage(named: weatherimages[2])
        case 13:
            cell.customImageView.image = UIImage(named: weatherimages[3])
        default:
            cell.customImageView.image = nil
        }
        
        self.stateOfWeather = weather.state
//        self.celsiusString = weather.celsiusString
//        self.rainfallProbabilityString = weather.rainfallProbabilityString
        
        return cell
    }
    
    
    
    //MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the new view controller using segue.destination.
        //Pass the selected object to the new view controller.
        
        guard let nextViewController: ThirdViewController = segue.destination as? ThirdViewController else {
            return
        }
        
        guard let cell: CustomTableViewCell = sender as? CustomTableViewCell else {
            return
        }
        
        nextViewController.setUiImageView = cell.customImageView.image
        nextViewController.textToSetTitle = cell.customFirstLabel.text
        nextViewController.setSecondLabel = cell.customSecondLabel.text
        nextViewController.setThirdLabel = cell.customThirdLabel.text
        nextViewController.setSecondLabelColor = cell.customSecondLabel.textColor
        nextViewController.setThirdLabelColor = cell.customThirdLabel.textColor
        nextViewController.returnStateOfWeather = self.stateOfWeather
    }
}
