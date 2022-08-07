//
//  AppConstant.swift
//  Weather Demo
//
//  Created by Brijesh on 03/08/22.
//
//****************************************************************************
//NOTE: - Please Do not change any (sesitive) value if you are not sure.
//****************************************************************************
import Foundation

enum AppConstants {
    static let apiKey = "0c32d09717042b14b08ac0955872e9e0"
    static let appName = "Weather"
    
}

enum ApiConstant {
    static let baseURL = "https://api.openweathermap.org/"
    static let units = "metric"
    static let limit = 5
    
    enum URLs {
        static let getWeather = baseURL + "data/2.5/weather"
        static let getLocation = baseURL + "geo/1.0/direct"
        static let getMultipleWeather = baseURL + "data/2.5/group"
    }
    

    enum QueryKey: String {
        case appid = "appid"
        case lon = "lon"
        case lat = "lat"

        case units = "units"
        case q = "q"
        case limit = "limit"
        case id = "id"
    }
}
