//
//  WeatherData.swift
//  Clima
//
//  Created by Офелия Баширова on 08.11.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
 
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable {
    let temp: Double
}

struct Weather: Codable  {
    let id: Int
}
