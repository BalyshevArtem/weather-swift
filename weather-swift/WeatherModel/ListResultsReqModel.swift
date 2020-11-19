//
//  ListResultsReqModel.swift
//  weather-swift
//
//  Created by Артем Балышев on 17.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import Foundation

class ListResultsReqModel: Codable {
    var dt: Float?
    var main: MainResultReqModel?
    var weather: [WeatherReqModel]?
    var dt_txt: String?
}
