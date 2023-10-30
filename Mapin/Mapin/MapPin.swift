//
//  MapPin.swift
//  Mapin
//
//  Created by Bruna Baudel on 25/10/23.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let locationDetails: LocationDetails?
    
    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil,
         subtitle: String? = nil,
         locationDetails: LocationDetails? = LocationDetails()) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.locationDetails = locationDetails
    }
}

struct LocationDetails: Identifiable {
    let id = UUID()
    
    var name: String?
    var city: String?
    var street: String?
    var zipCode: String?
    var country: String?
    
    var latitude: Double?
    var longitude: Double?
    var coordinate: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
