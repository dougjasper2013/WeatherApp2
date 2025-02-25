//
//  WeatherWidgit.swift
//  WeatherWidgit
//
//  Created by Douglas Jasper on 2025-02-20.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct WeatherEntry: TimelineEntry {
    let date: Date
    let cityWeather: CityWeather?
}

struct Provider: TimelineProvider {
    let locationManager = LocationManager()
    
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), cityWeather: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        Task {
            let entry = await fetchWeatherEntry()
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task {
            let entry = await fetchWeatherEntry()
            //let timeline = Timeline(entries: [entry], policy: .hourly)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(15))) // Refresh every hour
            completion(timeline)
        }
    }
    
    private func fetchWeatherEntry() async -> WeatherEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.triosdj.WeatherApp2")

        if let locationArray = sharedDefaults?.array(forKey: "lastLocation") as? [Double], locationArray.count == 2 {
            let latitude = locationArray[0]
            let longitude = locationArray[1]

            print("📍 Widget retrieved location: \(latitude), \(longitude)")  // ✅ Debugging Print

            do {
                let roundedLat = Double(String(format: "%.4f", latitude)) ?? latitude
                                let roundedLon = Double(String(format: "%.4f", longitude)) ?? longitude
                                let weather = try await WeatherService.shared.fetchWeather(for: "\(roundedLat),\(roundedLon)")
                return WeatherEntry(date: Date(), cityWeather: weather)
            } catch {
                print("❌ Error fetching weather: \(error)")
                return WeatherEntry(date: Date(), cityWeather: nil)
            }
        } else {
            print("❌ No location data found in UserDefaults")  // ✅ Debugging Print
            return WeatherEntry(date: Date(), cityWeather: nil)
        }
    }



}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry
    

    var body: some View {
        VStack {
            if let weather = entry.cityWeather {
                Image(systemName: weather.weatherIcon)
                    .font(.largeTitle)
                Text(weather.name)
                    .font(.headline)
                Text(weather.temperatureString)
                    .font(.title)
            } else {
                Text("Fetching location...")
                    .font(.footnote)
            }
        }
        .containerBackground(.background, for: .widget)
    }
}

//@main
struct WeatherWidgit: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Local Weather")
        .description("Shows current weather for your location.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


//@main
//struct WeatherWidgits: WidgetBundle {
//    @WidgetBundleBuilder
 //   var body: some Widget {
 //       WeatherWidgit()
 //   }
//}

//#Preview(as: .systemSmall) {
//    WeatherWidgit()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
