//
//  WeatherModel.swift
//  Weather Demo
//
//  Created by Brijesh on 04/08/22.
//

import Foundation

struct MultiWeatherModel: Decodable {
    var list: [WeatherModel]
    var cnt: Int = 0
}

struct WeatherModel: Decodable, Identifiable {
    var coord: CoordinatesResponse?
    var weather: [WeatherResponse]?
    var main: MainResponse?
    var name: String?
    var wind: WindResponse?
    var visibility:Double? = 0.0
    var id:Int = 0
    var sys : SysResponse?
    
    func getVisibility() -> String {
        return "\(visibility ?? 0.0)"
    }
    
    func getWeather() -> WeatherResponse?{
        if((weather?.count ?? 0) > 0) {
            return weather?.first
        }
        return nil
    }

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
        
        func getTemp() -> String {
            return "\(temp)º"
        }
        
        func getMaxTemp() -> String {
            return "\(temp_max)º"
        }
        
        func getMinTemp() -> String {
            return "\(temp_min)º"
        }
        
        func getPressure() -> String {
            return "\(pressure)hPa"
        }
        
        func getHumidity() -> String {
            return "\(humidity)%"
        }
        
        func getFeelsLike() -> String {
            return "\(feels_like)%"
        }
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
        
        func getSpeed() -> String {
            return "\(speed) kmph"
        }
        
        func getDegree() -> String {
            return "\(deg)º"
        }
    }
    
    struct SysResponse: Decodable {
        var sunrise: Double
        var sunset: Double
        var country: String?
        
        func getSunrise() -> String {
            return DateUtilities.dateFromTimeStamp(timestamp: sunrise)
        }
        
        func getSunset() -> String {
            return DateUtilities.dateFromTimeStamp(timestamp: sunset)
        }
        
        func getCountryName() -> String {
            return StringUtils.countryNameFromLocaleCode(localeCode: country ?? "")
        }
    }
}

