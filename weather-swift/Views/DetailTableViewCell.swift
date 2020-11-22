//
//  TableViewCell.swift
//  weather-swift
//
//  Created by Артем Балышев on 20.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    var dateWeatherLabel = UILabel()
    var smileWeatherLabel = UILabel()
    var temperaturesLabel = UILabel()

    override var reuseIdentifier: String? {
        return "DetailTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupLabel(labelView: dateWeatherLabel, fontSize: 20, text: "")
        setupLabel(labelView: smileWeatherLabel, fontSize: 29, text: "")
        setupLabel(labelView: temperaturesLabel, fontSize: 22, text: "")
        
        constraintsForDateWeatherLabel()
        constraintsForSmileWeatherLabel()
        constraintsForTemperaturesWeatherLabel()
        
        self.backgroundColor = .clear
    }
  

    fileprivate func setupLabel(labelView: UILabel, fontSize: CGFloat, text: String) {
        self.addSubview(labelView)

        labelView.text = text
        labelView.font = .systemFont(ofSize: fontSize)
        labelView.sizeToFit()
        labelView.textAlignment = .center        
        labelView.textColor = .white
        labelView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - constraints for labels
    
    fileprivate func constraintsForDateWeatherLabel() {
        dateWeatherLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.frame.width / 20).isActive = true
        dateWeatherLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    fileprivate func constraintsForSmileWeatherLabel() {
        smileWeatherLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        smileWeatherLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    fileprivate func constraintsForTemperaturesWeatherLabel() {
        temperaturesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.frame.width / 10).isActive = true
        temperaturesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    //MARK: - func for updating cell
    
    public func updateCell(dateString: String, smileString: String, temperaturesString: String) {
        self.temperaturesLabel.text = temperaturesString
        self.smileWeatherLabel.text = smileString
        self.dateWeatherLabel.text = dateString
    }
}
