//
//  WeatherView.swift
//  weather-swift
//
//  Created by Артем Балышев on 19.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    var cityLabel = UILabel()
    var weatherDetailLabel = UILabel()
    var temperatureLabel = UILabel()
    var gradusSignLabel = UILabel()
    var maxMinTemperatureLabel = UILabel()
    var weatherSmileLabel = UILabel()
    var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        setupWeatherSmileLabel()
        
        setupLabel(labelView: temperatureLabel, fontSize: 90, text: "")
        constraintForTempLabel()
        
        setupLabel(labelView: gradusSignLabel, fontSize: 80, text: "º")
        constraintForGradusSignLabel()
        
        setupLabel(labelView: weatherDetailLabel, fontSize: 20, text: "")
        constraintForWeatherDetailLabel()
        
        setupLabel(labelView: cityLabel, fontSize: 29, text: "")
        constraintForCityLabel()
        
        setupLabel(labelView: maxMinTemperatureLabel, fontSize: 16, text: "")
        constraintForMaxMinTempLabel()
        
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    //MARK: - Set up labelsView
    
    fileprivate func setupWeatherSmileLabel() {
        weatherSmileLabel.numberOfLines = 2
        weatherSmileLabel.lineBreakMode = .byCharWrapping
        weatherSmileLabel.text = ""
        weatherSmileLabel.font = .systemFont(ofSize: 25)
        weatherSmileLabel.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height / 6)
        self.addSubview(weatherSmileLabel)
    }
    
    fileprivate func setupLabel(labelView: UILabel, fontSize: CGFloat, text: String) {
        self.addSubview(labelView)

        labelView.text = text
        labelView.font = .systemFont(ofSize: fontSize)
        labelView.sizeToFit()
        labelView.textAlignment = .center
        
        labelView.textColor = .white
        
    }
    
    
    //MARK: - Set up constraints for all labels
    
    fileprivate func constraintForGradusSignLabel() {
        gradusSignLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gradusSignLabel.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor).isActive = true
        gradusSignLabel.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
    }
    
    fileprivate func constraintForCityLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cityLabel.centerYAnchor.constraint(equalTo: weatherDetailLabel.centerYAnchor, constant: -self.frame.maxY / 10).isActive = true
    }
    
    fileprivate func constraintForWeatherDetailLabel() {
        weatherDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weatherDetailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        weatherDetailLabel.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor, constant: -self.frame.maxY / 8).isActive = true
    }
    
    fileprivate func constraintForTempLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.frame.maxX / 6).isActive = true
    }
    
    fileprivate func constraintForMaxMinTempLabel() {
        maxMinTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        maxMinTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        maxMinTemperatureLabel.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor, constant: self.frame.maxY / 8).isActive = true
    }
    
    
    //MARK: - function of updating our view with new weather data
    
    public func updateWeatherView(temperature: Int, cityName: String, currentWeather: String, maxTemperature: Int, minTemperature: Int, weatherSmile: String) {
        temperatureLabel.text = String(temperature)
        maxMinTemperatureLabel.text = "max: " + String(maxTemperature) + "º" + ", min: " + String(minTemperature) + "º"
        cityLabel.text = cityName
        let previousWeatherDetailText = weatherDetailLabel.text!
        weatherDetailLabel.text = currentWeather
        weatherSmileLabel.text = weatherSmile
        
        guard (previousWeatherDetailText != currentWeather) && (currentWeather == "Clear" || previousWeatherDetailText == "Clear") || (previousWeatherDetailText == "") else {
            return
        }
        
        if currentWeather == "Clear" {
            gradientLayer.colors =  [#colorLiteral(red: 0.2484901692, green: 0.6803693342, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.01798000393, green: 0.6139364396, blue: 1, alpha: 1).cgColor]
            self.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.colors =  [UIColor.lightGray.cgColor, UIColor.gray.cgColor]
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
