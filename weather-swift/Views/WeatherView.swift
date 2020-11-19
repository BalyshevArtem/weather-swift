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
    var maxMinTemperatureLabel = UILabel()

    var weatherSmileLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        setupWeatherSmileLavel()
        
        setupLabel(labelView: temperatureLabel, fontSize: 90, text: "")
        constraintForTempLabel()
        
        setupLabel(labelView: weatherDetailLabel, fontSize: 20, text: "")
        constraintForWeatherDetailLabel()
        
        setupLabel(labelView: cityLabel, fontSize: 29, text: "")
        constraintForCityLabel()
        
        setupLabel(labelView: maxMinTemperatureLabel, fontSize: 19, text: "")
        constraintForMaxMinTempLabel()
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors =  [UIColor.gray.cgColor, UIColor.lightGray.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    fileprivate func setupWeatherSmileLavel() {
        weatherSmileLabel.numberOfLines = 2
        weatherSmileLabel.lineBreakMode = .byCharWrapping
        weatherSmileLabel.text = "💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧💧"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateWeatherView(temperature: Int, cityName: String, currentWeather: String, maxTemperature: Int, minTemperature: Int) {
        temperatureLabel.text = String(temperature) + "º"
        maxMinTemperatureLabel.text = "max: " + String(maxTemperature) + "º" + ", min: " + String(minTemperature) + "º"
        cityLabel.text = cityName
        weatherDetailLabel.text = currentWeather
    }
    
//    fileprivate func animateWeatherSmileLabel() {
//        let startFrame = self.weatherSmileLabel.frame
//        UIView.animate(withDuration: 2, delay: 0.0, options: .curveLinear, animations: {
//            var rainFrame = self.weatherSmileLabel.frame
//            rainFrame.origin.y = self.frame.maxY
//
//            self.weatherSmileLabel.frame = rainFrame
//
//        }) { finished in
//            self.weatherSmileLabel.frame = startFrame
//            self.animateWeatherSmileLabel()
//        }
//
//    }
    
}
