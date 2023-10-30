//
//  LocationManager.swift
//  Mapin
//
//  Created by Bruna Baudel on 25/10/23.
//

import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapPins: [MapPin] = []
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: .zero, longitude: .zero), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180))
    
    private var locationStatus: CLAuthorizationStatus? = .notDetermined
    private let locationManager = CLLocationManager()
    
    internal var isCurrentLocation: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationStatus = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.locationStatus == .authorizedWhenInUse || self.locationStatus == .authorizedAlways {
            guard let location = locations.last else { return }
            region = MKCoordinateRegion(center: location.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            locationManager.stopUpdatingLocation()
            isCurrentLocation = true
        }
   }
}
