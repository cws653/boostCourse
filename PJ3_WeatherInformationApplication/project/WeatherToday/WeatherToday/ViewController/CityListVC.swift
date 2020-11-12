//
//  SecondViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/01.
//  Copyright © 2020 최원석. All rights reserved.


import UIKit


class CityListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier: String = "cell"
    var countryName: String?
    var stateOfWeather: Int?
    
    var weathers: [Weather] = []
    let weatherimages = ["cloudy", "sunny","rainy","snowy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = .blue
        self.title = countryName
        self.navigationController?.navigationBar.tintColor = .white

        let jsonDecoder: JSONDecoder = JSONDecoder()
        var dataAsset: NSDataAsset?
        
        if title == "한국" {
            dataAsset = NSDataAsset(name: "kr")
        } else if title == "독일" {
            dataAsset = NSDataAsset(name: "de")
        }  else if title == "이탈리아" {
            dataAsset = NSDataAsset(name: "it")
        } else if title == "미국" {
            dataAsset = NSDataAsset(name: "us")
        } else if title == "프랑스" {
            dataAsset = NSDataAsset(name: "fr")
        } else if title == "일본" {
            dataAsset = NSDataAsset(name: "jp")
        }
        
        do {
            self.weathers = try jsonDecoder.decode([Weather].self, from: dataAsset!.data)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CityListCVC = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CityListCVC  else {
            return UITableViewCell()
        }
        
        let weather: Weather = self.weathers[indexPath.row]
        
        cell.cityNameLabel.text = weather.cityName
        cell.temperatureLabel.text = weather.celsiusString
        cell.precipitationLabel.text = weather.rainfallProbabilityString
        cell.selectionStyle = .none
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let wetherCelsius = weather.celsius
        if wetherCelsius < 10 {
            cell.temperatureLabel.textColor = .blue
        } else {
            cell.temperatureLabel.textColor = .black
        }
        
        let weatherRainFallProbability = weather.rainfallProbability
        if weatherRainFallProbability > 50 {
            cell.precipitationLabel.textColor = .orange
        } else {
            cell.precipitationLabel.textColor = .black
        }
   
        let weatherState = weather.state
        switch weatherState {
        case 10: cell.weatherImageView.image = UIImage(named: weatherimages[1])
        case 11: cell.weatherImageView.image = UIImage(named: weatherimages[0])
        case 12: cell.weatherImageView.image = UIImage(named: weatherimages[2])
        case 13: cell.weatherImageView.image = UIImage(named: weatherimages[3])
        default: cell.weatherImageView.image = nil
        }
        
        self.stateOfWeather = weather.state
        return cell
    }
    
    
    
    //MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the new view controller using segue.destination.
        //Pass the selected object to the new view controller.
        
        guard let nextViewController: WeatherDetailsVC = segue.destination as? WeatherDetailsVC else {
            return
        }
        
        guard let cell: CityListCVC = sender as? CityListCVC else {
            return
        }
        
        nextViewController.setWeatherImageView = cell.weatherImageView.image
        nextViewController.cityName = cell.cityNameLabel.text
        nextViewController.setTemperatureLabel = cell.temperatureLabel.text
        nextViewController.setPrecipitationLabel = cell.precipitationLabel.text
        nextViewController.setTemperatureLabelColor = cell.temperatureLabel.textColor
        nextViewController.setPrecipitationLabelColor = cell.precipitationLabel.textColor
        nextViewController.stateOfWeather = self.stateOfWeather
    }
}
