//
//  ViewController.swift
//  WeatherToday
//
//  Created by 최원석 on 2020/07/28.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class WorldCountryListViewController: UIViewController {
    
    @IBOutlet private weak var worldCountryListTableView: UITableView!
    private let cellIdentifier: String = "worldCountryTableViewCell"
    private var countryModel: [CountryModel] = []
    private let flagimages = ["flag_kr","flag_de","flag_it","flag_us","flag_fr","flag_jp"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationControllerAttributes()
        setCountryModel()
    }

    private func setTableView() {
        self.worldCountryListTableView.delegate = self
        self.worldCountryListTableView.dataSource = self
    }

    private func setNavigationControllerAttributes() {
        self.navigationController?.navigationBar.barTintColor = .blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    private func setCountryModel() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "countries") else { return }
        do {
            self.countryModel = try jsonDecoder.decode([CountryModel].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        self.worldCountryListTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: CityListViewController = segue.destination as? CityListViewController else { return }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        nextViewController.countryName = cell.textLabel?.text
    }
}

extension WorldCountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryModel.count
    }

    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)

        let country: CountryModel = self.countryModel[indexPath.row]

        cell.textLabel?.text = country.koreanName
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none

        let countryName: String = country.assetName
        switch countryName {
        case "kr": cell.imageView?.image = UIImage(named: flagimages[0])
        case "de": cell.imageView?.image = UIImage(named: flagimages[1])
        case "it": cell.imageView?.image = UIImage(named: flagimages[2])
        case "us": cell.imageView?.image = UIImage(named: flagimages[3])
        case "fr": cell.imageView?.image = UIImage(named: flagimages[4])
        case "jp": cell.imageView?.image = UIImage(named: flagimages[5])
        default: cell.imageView?.image = nil
        }
        return cell
    }
}
