//
//  WeatherManager.swift
//  Weather Demo
//
//  Created by Brijesh on 04/08/22.
//

import Foundation

class WeatherManager {
    
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherModel {
        guard let url = URL(string: "\(ApiConstant.URLs.getWeather)?\(ApiConstant.QueryKey.lat)=\(latitude)&\(ApiConstant.QueryKey.lon)=\(longitude)&\(ApiConstant.QueryKey.appid)=\(AppConstants.apiKey)&\(ApiConstant.QueryKey.units)=\(ApiConstant.units)") else { fatalError("Missing URL") }


        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
        
        return decodedData
    }
    
    func getMultipleCurrentWeather(groupIds: [Int]) async throws -> MultiWeatherModel {
        let arr = groupIds.map { obj in
            return "\(obj)"
        }
        guard let url = URL(string: "\(ApiConstant.URLs.getMultipleWeather)?\(ApiConstant.QueryKey.id)=\(arr.joined(separator: ","))&\(ApiConstant.QueryKey.appid)=\(AppConstants.apiKey)&\(ApiConstant.QueryKey.units)=\(ApiConstant.units)") else { fatalError("Missing URL") }


        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        let decodedData = try JSONDecoder().decode(MultiWeatherModel.self, from: data)
        
        return decodedData
    }
    
    func getLocation(query: String) async throws -> [LocationModel] {
        guard let url = URL(string: "\(ApiConstant.URLs.getLocation)?\(ApiConstant.QueryKey.q)=\(query)&\(ApiConstant.QueryKey.appid)=\(AppConstants.apiKey)&\(ApiConstant.QueryKey.limit)=\(ApiConstant.limit)") else { fatalError("Missing URL") }


        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        let decodedData = try JSONDecoder().decode([LocationModel].self, from: data)
        
        return decodedData
    }
}
