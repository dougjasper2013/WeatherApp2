//
//  LocationManager.swift
//  WeatherApp2
//
//  Created by Douglas Jasper on 2025-02-24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()  // ✅ Ask for permission
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("❌ Location permission not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("❌ Location permission denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted")
            locationManager.startUpdatingLocation() // ✅ Start getting location updates
        @unknown default:
            print("⚠️ Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("📍 New location: \(latitude), \(longitude)")  // ✅ Debugging Print

            // Save location in UserDefaults (App Group)
            if let sharedDefaults = UserDefaults(suiteName: "group.com.triosdj.WeatherApp2") {
                sharedDefaults.set([latitude, longitude], forKey: "lastLocation")
                sharedDefaults.synchronize()
                print("✅ Location saved in UserDefaults")
            } else {
                print("❌ Failed to access shared UserDefaults")
            }
        }
    }
}
