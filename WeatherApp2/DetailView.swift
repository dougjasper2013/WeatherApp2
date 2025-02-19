//
//  DetailView.swift
//  WeatherApp2
//
//  Created by Douglas Jasper on 2025-02-19.
//

import SwiftUI

struct DetailView: View {
    let cityName: String
    @State private var weatherDetail: WeatherDetail?
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Fetching details...")
            } else if let weather = weatherDetail {
                Text(weather.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("\(weather.main.temp, specifier: "%.1f")°C")
                    .font(.system(size: 50))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Text(weather.weather.first?.description.capitalized ?? "Clear")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Text("Humidity: \(weather.main.humidity)%")
                    .font(.body)
                    .padding()
                
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Weather Details")
        .task {
            await loadWeatherDetail()
        }
    }

    private func loadWeatherDetail() async {
        do {
            weatherDetail = try await WeatherService.shared.fetchWeatherDetail(for: cityName)
            isLoading = false
        } catch {
            print("Error fetching weather details: \(error)")
        }
    }
}


#Preview {
    DetailView(cityName: "Windsor")
}
