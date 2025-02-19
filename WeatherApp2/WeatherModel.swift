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
    let condition: String
    
    var temperatureString: String {
        String(format: "%.1f°C", temperature)
    }

    var weatherIcon: String {
        switch condition.lowercased() {
        case "clear sky": return "sun.max.fill"
        case "few clouds", "scattered clouds", "broken clouds": return "cloud.sun.fill"
        case "overcast clouds": return "cloud.fill"
        case "shower rain","light rain", "moderate rain", "heavy rain", "rain": return "cloud.rain.fill"
        case "thunderstorm": return "cloud.bolt.rain.fill"
        case "snow": return "snowflake"
        case "mist", "fog", "haze": return "cloud.fog.fill"
        default: return "questionmark.circle.fill"
        }
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


