//
//  SecondViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/08/01.
//  Copyright © 2020 최원석. All rights reserved.


import UIKit


class CityListViewController: UIViewController {
    
    @IBOutlet weak var cityListTableView: UITableView!
    
    private let cellIdentifier: String = "cityListTableViewCell"
    private var weatherModel: [WeatherModel] = []
    private let weatherimages = ["cloudy", "sunny","rainy","snowy"]
    var countryName: String?
    var stateOfWeather: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setNavigationBarAttributes()
        setWeatherModel()
    }

    private func setTableView() {
        self.cityListTableView.delegate = self
        self.cityListTableView.dataSource = self
    }

    private func setNavigationBarAttributes() {
        self.navigationController?.navigationBar.barTintColor = .blue
        self.title = countryName
        self.navigationController?.navigationBar.tintColor = .white
    }

    private func setWeatherModel() {
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
            self.weatherModel = try jsonDecoder.decode([WeatherModel].self, from: dataAsset!.data)
        } catch {
            print(error)
        }
        self.cityListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherModel.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: WeatherDetailsViewController = segue.destination as? WeatherDetailsViewController else { return }
        
        guard let cell: CityListTableViewCell = sender as? CityListTableViewCell else {
            return
        }

        nextViewController.weatherModel = cell.weatherModel
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell: CityListTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CityListTableViewCell  else {
            return UITableViewCell()
        }
        let weather: WeatherModel = self.weatherModel[indexPath.row]
        cell.weatherModel = weather

        return cell
    }
}
