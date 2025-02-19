//
//  ContentView.swift
//  WeatherApp2
//
//  Created by Douglas Jasper on 2025-02-19.
//

import SwiftUI

struct ContentView: View {
    @State private var cities = ["Vancouver", "Calgary", "Edmonton", "Regina", "Winnipeg",
        "Toronto", "Montreal", "Quebec City", "Halifax"]
    @State private var weatherData: [CityWeather] = []
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Fetching Weather...")
            } else {
                List(weatherData) { city in
                    NavigationLink(destination: DetailView(cityName: city.name)) {
                        HStack {
                            Text(city.name)
                                .font(.headline)
                            Spacer()
                            Text(city.temperatureString)
                                .foregroundColor(.blue)
                        }
                        .padding(5)
                    }
                }
                .navigationTitle("Weather App")
            }
        }
        .task {
            await loadWeather()
        }
    }

    private func loadWeather() async {
        do {
            weatherData = try await withThrowingTaskGroup(of: CityWeather?.self) { group in
                for city in cities {
                    group.addTask {
                        try? await WeatherService.shared.fetchWeather(for: city)
                    }
                }

                var results: [CityWeather] = []
                for try await result in group {
                    if let weather = result {
                        results.append(weather)
                    }
                }
                return results
            }
            isLoading = false
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
}


#Preview {
    ContentView()
}
