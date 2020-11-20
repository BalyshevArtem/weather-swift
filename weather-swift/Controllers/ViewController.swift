//
//  ViewController.swift
//  weather-swift
//
//  Created by Артем Балышев on 17.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UISearchResultsUpdating, UIGestureRecognizerDelegate {
    
    var timer: Timer = Timer()
    var weatherView: WeatherView!
    var model: ResultRequestModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRootVC()
        
        //Добавление перехода к Detail VC
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(goToDetailVC))
        recognizer.delegate = self
        self.weatherView.addGestureRecognizer(recognizer)
    }
    
    fileprivate func setupRootVC() {
        self.navigationItem.title = "weather-swift"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Input city"
        searchController.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.weatherView = WeatherView(frame: CGRect(x: self.view.frame.maxX / 12, y: (self.navigationController!.navigationBar.frame.maxY) + self.view.frame.maxY / 6, width: self.view.frame.maxX - self.view.frame.maxX / 6, height: self.view.frame.maxY - self.navigationController!.navigationBar.frame.maxY - self.view.frame.maxY / 4))
        self.view.addSubview(weatherView)
        weatherView.isHidden = true
    }
    
    //MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let city = searchController.searchBar.text!
        
        guard city != "" else {
            return
        }
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            NetworkManager.shared.getWeather(for: city) { (model) in
                if let model = model {
                    self.model = model
                    DispatchQueue.main.async {
                        self.unpackingModelAndUpdateWeatherView(model: model)
                        self.weatherView.isHidden = false
                    }
                }
            }
        }
    }
    
    //MARK: - function of unpacking our Weather Model and update weather view
    
    fileprivate func unpackingModelAndUpdateWeatherView(model: ResultRequestModel) {
        let cityName = model.city?.name
        let temperature = model.list?.first?.main?.temp
        let maxTemp = model.list?.first?.main?.temp_max
        let minTemp = model.list?.first?.main?.temp_min
        let weatherDiscription = model.list?.first?.weather?.first?.main
        var weatherSmile = ""
        
        switch weatherDiscription {
        case "Clouds":
            weatherSmile = WeatherSmileEnum.clouds.rawValue
        case "Rain":
            weatherSmile = WeatherSmileEnum.rain.rawValue
        case "Clear":
            weatherSmile = WeatherSmileEnum.clear.rawValue
        default:
            weatherSmile = ""
        }
        
        weatherView.updateWeatherView(temperature: Int(temperature ?? -1000), cityName: cityName ?? "Something went wrong", currentWeather: weatherDiscription ?? "Something went wrong", maxTemperature: Int(maxTemp ?? -1000), minTemperature: Int(minTemp ?? -1000), weatherSmile: weatherSmile)
    }
    
    //MARK: - function for switching to a new view controller
    
    @objc func goToDetailVC(recognizer: UITapGestureRecognizer) {
        let detailVC = DetailViewController(model: self.model)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

