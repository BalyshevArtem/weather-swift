//
//  ResultRequestModel.swift
//  weather-swift
//
//  Created by Артем Балышев on 17.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import Foundation

class ResultRequestModel: Codable {
    var cod: String?
    var message: Float?
    var cnt: Float?
    var list: [ListResultsReqModel]?
    var city: CityModel?
    
}
