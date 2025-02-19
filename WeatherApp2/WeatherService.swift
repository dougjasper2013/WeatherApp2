//
//  WeatherService.swift
//  WeatherApp2
//
//  Created by Douglas Jasper on 2025-02-19.
//

import Foundation

class WeatherService {
    static let shared = WeatherService()
    private let apiKey = "7c7dff744a0d790a33dbdc3182a1f7aa" // 🔥 Replace with your OpenWeather API key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for city: String) async throws -> CityWeather {
        let urlString = "\(baseURL)?q=\(city)&units=metric&appid=\(apiKey)"
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedData = try JSONDecoder().decode(WeatherDetail.self, from: data)
        let condition = decodedData.weather.first?.description ?? "Unknown"
        
        return CityWeather(name: decodedData.name, temperature: decodedData.main.temp, condition: condition)
    }
    
    func fetchWeatherDetail(for city: String) async throws -> WeatherDetail {
            let urlString = "\(baseURL)?q=\(city)&units=metric&appid=\(apiKey)"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
     
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(WeatherDetail.self, from: data)
        }
    
}
