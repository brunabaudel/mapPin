//
//  ContentView.swift
//  Mapin
//
//  Created by Bruna Baudel on 25/10/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var readyToNavigate: Bool = false
    @State private var mapPinSelected: MapPin? = nil

    var body: some View {
        
        NavigationStack {
            MapView(currentLocation: $locationManager.region,
                    mapPins: $locationManager.mapPins,
                    isCurrentLocation: $locationManager.isCurrentLocation) { pin in
                readyToNavigate = true
                mapPinSelected = pin
            }
            .navigationTitle("Map Explorer")
            .navigationDestination(isPresented: $readyToNavigate) {
                LocationDetailsView(mapPin: mapPinSelected)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
