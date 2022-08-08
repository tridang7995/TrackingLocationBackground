//
//  MapViewModel.swift
//  TrackingLocationOnBackground
//
//  Created by Tri Dang on 07/08/2022.
//

import Combine
import MapKit

extension MapView {
    @MainActor class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var locationsSaved: [Location] = []
        var locationManager: CLLocationManager = CLLocationManager()
        @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
        @Published var didAddedLocation: Location?
        private var cancelled = Set<AnyCancellable>()

        override init() {
            super.init()
            locationManager.delegate = self
        }

        func locationManager(_ manager: CLLocationManager,
                             didFailWithError error: Error) {
            print("error:: \(error.localizedDescription)")
        }

        func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted, .denied:
                break
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                locationManager.allowsBackgroundLocationUpdates = true
            case .authorizedWhenInUse:
                locationManager.requestAlwaysAuthorization()
                locationManager.allowsBackgroundLocationUpdates = true
            case .authorized:
                locationManager.startUpdatingLocation()
                locationManager.allowsBackgroundLocationUpdates = true
            @unknown default:
                break
            }
        }

        func locationManager(_ manager: CLLocationManager,
                             didUpdateLocations locations: [CLLocation]) {
            if locations.first != nil {
                let locate = Location(
                    coordinate: Coordinate.map(withCLLocationCoordinate2D: locations.last!.coordinate)
                )
                locationsSaved.append(locate)
                didAddedLocation = locate
            }
        }
    }
}
