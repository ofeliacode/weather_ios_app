//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
   
    //структура где парсим json
    var weatherManager = WeatherManager()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTF.endEditing(true)
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
           return true
        } else {
            textField.placeholder = "Search"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTF.text {
            //тут получаем город и выводим в соотвествии с городом
            weatherManager.fetchWeather(cityName: city)
        }
        searchTF.text = ""
    }
}
extension WeatherViewController: WeatherManagerDelegate {
    //делегат
    func didUpdetedWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
