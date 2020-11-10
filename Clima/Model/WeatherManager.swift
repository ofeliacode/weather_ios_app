//
//  WeatherManager.swift
//  Clima
//
//  Created by Офелия Баширова on 08.11.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdetedWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    let weatherURL =
        "https://api.openweathermap.org/data/2.5/weather?appid=d88d5d3db2205fae931fb869ebe8ca2f&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String)  {
       let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
         let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdetedWeather(self, weather: weather)
                }
            }
            
        }.resume()
    }
}
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}

