//
//  NetworkManager.swift
//  weather-swift
//
//  Created by Артем Балышев on 17.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import Foundation
import Network

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()

    private init() {}
    
    fileprivate var modelsCache = NSCache<NSString, ResultRequestModel>()
        
    public func getWeather(for city: String, resultClosure: @escaping ( (ResultRequestModel?, Int?)->() )) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "lang", value: "ru"),
                                    URLQueryItem(name: "units", value: "metric"),
                                    URLQueryItem(name: "appid", value: "560101761672e21ef08fd8e981a10d86")]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        if let cashedModel = modelsCache.object(forKey: urlComponents.url!.absoluteString as NSString) {
            resultClosure(cashedModel, 200)
            return
        }
        
        let task = URLSession(configuration: .default)
        let dataTask = task.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if error == nil {
                let decoder = JSONDecoder()
                var decoderModel: ResultRequestModel?
                
                if data != nil {
                    decoderModel = try? decoder.decode(ResultRequestModel.self, from: data!)
                    if decoderModel != nil {
                        self.modelsCache.setObject(decoderModel!, forKey: request.url!.absoluteString as NSString)
                    }
                    resultClosure(decoderModel, statusCode)
                }
            } else {
                    resultClosure(nil, statusCode)
            }
        }
        
        dataTask.resume()
    }
}
