//
//  LocationDetailsView.swift
//  Mapin
//
//  Created by Bruna Baudel on 26/10/23.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    let mapPin: MapPin?
    
    var body: some View {
        if let mapPin, let locationDetails = mapPin.locationDetails {
            VStack {
                
                Text(locationDetails.name ?? "")
                    .font(.title)
                Text(locationDetails.country ?? "")
                    .font(.title2)
                
                HStack {
                    Text("\(locationDetails.city ?? ""), \(locationDetails.street ?? ""). \(locationDetails.zipCode ?? "") ")
                }
                
                Text("\(mapPin.coordinate.latitude) - \(mapPin.coordinate.longitude)")
                Spacer()
            }
        }
    }
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(mapPin: MapPin(coordinate: CLLocationCoordinate2D()))
    }
}
