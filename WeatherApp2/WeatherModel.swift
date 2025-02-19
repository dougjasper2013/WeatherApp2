//
//  WeatherModel.swift
//  WeatherApp2
//
//  Created by Douglas Jasper on 2025-02-19.
//

import Foundation

struct CityWeather: Identifiable, Codable {
    let id = UUID()
    let name: String
    let temperature: Double
    
    var temperatureString: String {
        String(format: "%.1f°C", temperature)
    }
}

struct WeatherDetail: Codable {
    let name: String
    let main: Main
    let weather: [Weather]

    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }

    struct Weather: Codable {
        let description: String
    }
}
