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
    var isAnimate: Bool = false
    var currentCity: String = ""
    
    var weatherView: WeatherView!
    var model: ResultRequestModel?
    var mainInformationLabel = UILabel()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRootVC()
        setUpMainInformationLabel()
        setUpSpinner()
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(goToDetailVC))
        
        recognizer.delegate = self
        self.weatherView.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - functions for set up spinnerView, mainInformLabel and our RootVC
    
    fileprivate func setUpSpinner() {
        self.view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isHidden = true
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setUpMainInformationLabel() {
        self.view.addSubview(mainInformationLabel)
        
        mainInformationLabel.text = "type city name in search bar"
        mainInformationLabel.font = .systemFont(ofSize: 22)
        mainInformationLabel.sizeToFit()
        mainInformationLabel.textAlignment = .center
        mainInformationLabel.textColor = .black
        mainInformationLabel.numberOfLines = 3
        mainInformationLabel.lineBreakMode = .byClipping
        
        mainInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        mainInformationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainInformationLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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
        
        self.weatherView = WeatherView(frame: CGRect(x: self.view.frame.maxX / 12,
                                                     y: self.navigationController!.navigationBar.frame.maxY + self.view.frame.maxY / 6,
                                                     width: self.view.frame.maxX - self.view.frame.maxX / 6,
                                                     height: self.view.frame.maxY - self.navigationController!.navigationBar.frame.maxY - self.view.frame.maxY / 4))
        self.view.addSubview(weatherView)
        weatherView.isHidden = true
    }
    
    //MARK: - functions for start and stop animate spinner
   
    fileprivate func startAnimationSpinner() {
        guard !isAnimate else {
            return
        }

        mainInformationLabel.isHidden = true
        weatherView.isHidden = true
        
        isAnimate = true
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    fileprivate func stopAnimatingSpinner() {
        isAnimate = false
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    //MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let city = searchController.searchBar.text!
        
        guard city != "" else {
            self.mainInformationLabel.text = "type city name in search bar"
            return
        }
        
        guard city != self.currentCity else {
            return
        }
        
        currentCity = city
        startAnimationSpinner()
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            NetworkManager.shared.getWeather(for: city) { (model, statusCode) in
                if let model = model {
                    self.model = model
                    DispatchQueue.main.async {
                        self.stopAnimatingSpinner()
                        self.unpackingModelAndUpdateWeatherView(model: model)
                        self.weatherView.isHidden = false
                        self.mainInformationLabel.isHidden = true
                    }
                } else if statusCode != nil {
                    DispatchQueue.main.async {
                        self.stopAnimatingSpinner()
                        self.weatherView.isHidden = true
                        self.mainInformationLabel.isHidden = false
                        self.mainInformationLabel.text = "there is no such city \n please, check the correctness"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.stopAnimatingSpinner()
                        self.weatherView.isHidden = true
                        self.mainInformationLabel.isHidden = false
                        self.mainInformationLabel.text = "please, check internet connection"
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
        case "Snow":
            weatherSmile = WeatherSmileEnum.snow.rawValue
        case "Storm":
            weatherSmile = WeatherSmileEnum.storm.rawValue
        default:
            weatherSmile = ""
        }
        
        weatherView.updateWeatherView(temperature: Int(temperature ?? -1000),
                                      cityName: cityName ?? "Something went wrong",
                                      currentWeather: weatherDiscription ?? "Something went wrong",
                                      maxTemperature: Int(maxTemp ?? -1000),
                                      minTemperature: Int(minTemp ?? -1000),
                                      weatherSmile: weatherSmile)
    }
    
    //MARK: - function for switching to a new view controller
    
    @objc func goToDetailVC(recognizer: UITapGestureRecognizer) {
        let isLightBackgroundColor = self.model?.list?.first?.weather?.first?.main == "Clear" ? true : false
      
        let detailVC = DetailViewController(model: self.model,
                                            isLightBackgroundColor: isLightBackgroundColor)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

