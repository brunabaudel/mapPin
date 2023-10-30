//
//  MapView.swift
//  Mapin
//
//  Created by Bruna Baudel on 25/10/23.
//

import MapKit
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    @Binding var currentLocation: MKCoordinateRegion    
    @Binding var mapPins: [MapPin]
    @Binding var isCurrentLocation: Bool

    var didSelect: ((MapPin) -> ())?
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        for pin in mapPins {
            mapView.addAnnotation(pin)
        }
        if isCurrentLocation {
            mapView.showsUserLocation = true
            mapView.setRegion(currentLocation, animated: true)
            isCurrentLocation = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        var gRecognizer = UILongPressGestureRecognizer()

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }

        @objc func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
            let mapLocation = gRecognizer.location(in: self.parent.mapView)
            let coordinate = self.parent.mapView.convert(mapLocation, toCoordinateFrom: self.parent.mapView)
            lookUpCurrentLocation(coordinate: coordinate) { location in
                self.parent.mapPins.append(location)
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            guard let pin = annotation as? MapPin else {
                return
            }
            
            self.parent.didSelect!(pin)
        }
        
        private func lookUpCurrentLocation(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (MapPin)->Void) {
            let geoCoder = CLGeocoder()
            let cclocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geoCoder.reverseGeocodeLocation(cclocation, completionHandler: { (placemarks, error) -> Void in
                guard let placeMark = placemarks?[0] else {return}
                
                var locationDetails = LocationDetails()
                locationDetails.latitude = coordinate.latitude
                locationDetails.longitude = coordinate.longitude
                
                if let name = placeMark.name {
                    locationDetails.name = name
                }
                
                if let country = placeMark.country {
                    locationDetails.country = country
                }
                
                if let city = placeMark.locality {
                    locationDetails.city = city
                }
                
                if let street = placeMark.thoroughfare {
                    locationDetails.street = street
                }
                
                if let zipCode = placeMark.postalCode {
                    locationDetails.zipCode = zipCode
                }
                
                let mapPin = MapPin(coordinate: coordinate,
                                    title: locationDetails.name,
                                    subtitle: locationDetails.street,
                                    locationDetails: locationDetails)
                
                completionHandler(mapPin)
            })
        }
    }
}
