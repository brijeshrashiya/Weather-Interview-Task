//
//  LocationModel.swift
//  Weather Demo
//
//  Created by Brijesh on 04/08/22.
//

import Foundation


struct LocationModel: Decodable, Identifiable {
    let id = UUID()
    var name: String
    var lon: Double
    var lat: Double
    var country: String
    var state: String?
    
    func getCountryName() -> String {
        StringUtils.countryNameFromLocaleCode(localeCode: country)
    }

    
}
