//
//  WeatherDetailViewModel.swift
//  Weather Interview Task
//
//  Created by Brijesh on 07/08/22.
//

import Foundation
import SwiftUI

class WeatherDetailViewModel: ObservableObject {
    private let weather: WeatherModel?
    
    // MARK: - Constructor
    init(wetherModel: WeatherModel?) {
        self.weather = wetherModel
    }
    
    var cityName: String {
        weather?.name ?? ""
    }
    
    var weatherImage : String {
        weather?.getWeather()?.icon ?? ""
    }
    
    var currentTemp : String {
        weather?.main?.getTemp() ?? "-"
    }
    
    var weatherDescription : String {
        "\(weather?.getWeather()?.main ?? "") - \(weather?.getWeather()?.description ?? "")"
    }
    
    var maxTemp : String {
        weather?.main?.getMaxTemp() ?? "-"
    }
    
    var minTemp : String {
        weather?.main?.getMinTemp() ?? "-"
    }
    
    var sunrise : String {
        weather?.sys?.getSunrise() ?? "-"
    }
    
    var sunset : String {
        weather?.sys?.getSunset() ?? "-"
    }
    
    var windSpeed : String {
        weather?.wind?.getSpeed() ?? "-"
    }
    
    var windDegree : String {
        weather?.wind?.getDegree() ?? "-"
    }
    
    var pressure : String {
        weather?.main?.getPressure() ?? "-"
    }
    
    var humidity : String {
        weather?.main?.getHumidity() ?? "-"
    }
    
    var visibility : String {
        weather?.getVisibility() ?? "-"
    }
    
    var feelsLike : String {
        weather?.main?.getFeelsLike() ?? "-"
    }
    
}
