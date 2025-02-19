//
//  ContentView.swift
//  WeatherApp2
//
//  Created by Douglas Jasper on 2025-02-19.
//

import SwiftUI

struct ContentView: View {
    @State private var cities: [String] = UserDefaults.standard.stringArray(forKey: "SavedCities") ?? ["New York", "London", "Tokyo"]
    @State private var weatherData: [CityWeather] = []
    @State private var isLoading = true
    @State private var newCity: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Add City TextField & Button
                HStack {
                    TextField("Enter city name", text: $newCity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)

                    Button(action: addCity) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                }
                .padding()

                // Weather List
                if isLoading {
                    ProgressView("Fetching Weather...")
                } else {
                    List {
                        ForEach(weatherData) { city in
                            NavigationLink(destination: DetailView(cityName: city.name)) {
                                HStack {
                                    Image(systemName: city.weatherIcon)
                                        .foregroundColor(.blue)
                                        .imageScale(.large)
                                    Text(city.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(city.temperatureString)
                                        .foregroundColor(.blue)
                                }
                                .padding(5)
                            }
                        }
                        .onDelete(perform: removeCity) // Swipe to delete
                    }
                    .navigationTitle("Weather App")
                }
            }
        }
        .task {
            await loadWeather()
        }
        .onAppear {
            Task {
                await loadWeather()
            }
        }
    }

    // 🔹 Fetch weather data
    private func loadWeather() async {
        guard !cities.isEmpty else { return } // Avoid unnecessary API calls

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

    // 🔹 Add a city
    private func addCity() {
        let city = newCity.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty, !cities.contains(city) else { return }

        cities.append(city)
        UserDefaults.standard.set(cities, forKey: "SavedCities") // Save to UserDefaults
        newCity = ""

        Task {
            await loadWeather()
        }
    }

    // 🔹 Remove a city
    private func removeCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
        UserDefaults.standard.set(cities, forKey: "SavedCities") // Save changes

        Task {
            await loadWeather()
        }
    }
}



#Preview {
    ContentView()
}
