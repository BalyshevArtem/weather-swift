//
//  DetailViewController.swift
//  weather-swift
//
//  Created by Артем Балышев on 20.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    fileprivate var model: ResultRequestModel?
    fileprivate var processedModel = [(String, String, String)]()
    fileprivate var dateFormatter = DateFormatter()
    
    var weatherTableView = UITableView()
    
    init(model: ResultRequestModel?) {
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        setUpWeatherTableView()
        
        proccesingModel()
        self.navigationController?.navigationBar.isHidden = true
    }

    fileprivate func setUpWeatherTableView() {
        weatherTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "DetailTableViewCell")
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.separatorStyle = .none
        weatherTableView.backgroundColor = .gray
        weatherTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(weatherTableView)
    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model, let list = model.list else {
            return 0
        }
      //  print(list.count)
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
        
        guard processedModel.count > 0 else {
            return cell
        }
        
        cell.updateCell(dateString: processedModel[indexPath.row].0, smileString: processedModel[indexPath.row].1, temperaturesString: processedModel[indexPath.row].2)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 13
    }
    
    //MARK: - function for format model
    
    fileprivate func proccesingModel() {
        guard let model = self.model, let list = model.list else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            for element in list {
                var dateString = ""
                var smileString = ""
                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let dt_txt = element.dt_txt, let date = self.dateFormatter.date(from: dt_txt) {
                    self.dateFormatter.dateFormat = "E  HH:mm"
                    dateString = self.dateFormatter.string(from: date)
                }
                switch element.weather?.first?.main ?? "" {
                case "Clouds":
                    smileString = "☁️"
                case "Rain":
                    smileString = "🌧"
                case "Clear":
                    smileString = "☀️"
                case "Snow":
                    smileString = "❄️"
                default:
                    smileString = ""
                }
                self.processedModel.append((dateString, smileString, String(Int(element.main?.temp ?? -1000))))
            }
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }
    }
}
