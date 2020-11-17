//
//  NetworkManager.swift
//  weather-swift
//
//  Created by Артем Балышев on 17.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import Foundation

class NetworkManager {
    private init() {}
    
    static let shared: NetworkManager = NetworkManager()
    
    func getWeather(for city: String, resultClosure: @escaping ( (ResultRequestModel?)->() )) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: city), URLQueryItem(name: "appid", value: "560101761672e21ef08fd8e981a10d86")]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        let dataTask = task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                var decoderModel: ResultRequestModel?
                
                if data != nil {
                    decoderModel = try? decoder.decode(ResultRequestModel.self, from: data!)
                }
                resultClosure(decoderModel)
            } else {
                print(error as Any)
            }
        }
        
        dataTask.resume()
    
    }
}