//
//  CountryList.swift
//  PrismaTest
//
//  Created by saeed shaikh on 06/01/25.
//

import UIKit
import Alamofire
import SDWebImage

struct Country {
    let name: String
    let flagURL: String
}


class CountryList: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchFieldChanged(_:)), for: .editingChanged)
        
        fetchCountryData()
        
    }
    
    
    
    func fetchCountryData() {
        let url = "https://countriesnow.space/api/v0.1/countries/flag/images"
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let data = json["data"] as? [[String: Any]] {
                    self.countries = data.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let flagURL = dict["flag"] as? String else { return nil }
                        return Country(name: name, flagURL: flagURL)
                    }
                    self.filteredCountries = self.countries // Initial data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error fetching country data: \(error.localizedDescription)")
                if let statusCode = response.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                }
                self.showAlert(title: "Network Error", message: "Unable to fetch country data. Please try again later.")
            }
        }
        
    }
    
}


//MARK: UITextFieldDelegate extension
extension CountryList: UITextFieldDelegate{
    
    // Search Field Change Handler
    @objc func searchFieldChanged(_ sender: UITextField) {
        guard let searchText = sender.text?.lowercased() else { return }
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { $0.name.lowercased().contains(searchText) }
        }
        tableView.reloadData()
    }
    
    // Dismiss Keyboard on "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: tableview extension
extension CountryList: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let country = filteredCountries[indexPath.row]
        cell.name.text = country.name
        
        if let url = URL(string: country.flagURL) {
            cell.countryImg.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            cell.countryImg.image = UIImage(systemName: "photo")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0 // Set row height
    }
    
}
