//
//  Weather_Interview_TaskApp.swift
//  Weather Interview Task
//
//  Created by Brijesh on 05/08/22.
//

import SwiftUI

@main
struct Weather_Interview_TaskApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherList()
                .preferredColorScheme(.dark)
        }
    }
}
