//
//  ClientMapView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct ClientMapView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    @State private var showDetails = false
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingSearchSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition, selection: $selectedResult) {
                // User's location marker
                if let location = locationManager.location {
                    Annotation("My Location", coordinate: location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 32, height: 32)
                                .opacity(0.3)
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 20, height: 20)
                            
                            Circle()
                                .fill(.blue)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                // Search results markers
                ForEach(results) { item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                        .tint(.indigo)
                }
                
                // Route overlay if available
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            .overlay(alignment: .top) {
                searchBar
                    .padding()
            }
            .overlay(alignment: .topTrailing) {
                VStack {
                    mapControls
                        .padding()
                    
                    if locationManager.location != nil {
                        userLocationButton
                            .padding(.trailing)
                    }
                }
            }
            .sheet(isPresented: $isShowingSearchSheet) {
                searchResultsList
                    .presentationDetents([.medium, .large])
            }
            .sheet(item: $selectedResult) { selection in
                locationDetailView(for: selection)
                    .presentationDetents([.medium])
            }
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search location...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .onSubmit {
                    search()
                }
                .onChange(of: searchText) {
                    if searchText.isEmpty {
                        results.removeAll()
                    }
                }
        }
        .padding(10)
        .background(.thinMaterial)
        .cornerRadius(10)
    }
    
    // MARK: - Map Controls
    private var mapControls: some View {
        VStack(spacing: 10) {
            Button {
                isShowingSearchSheet.toggle()
            } label: {
                Image(systemName: "list.bullet")
                    .frame(width: 44, height: 44)
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - User Location Button
    private var userLocationButton: some View {
        Button {
            if let location = locationManager.location {
                withAnimation {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    ))
                }
            }
        } label: {
            Image(systemName: "location.fill")
                .frame(width: 44, height: 44)
                .background(.thinMaterial)
                .cornerRadius(10)
        }
    }
    
    // MARK: - Search Results List
    private var searchResultsList: some View {
        NavigationView {
            List(results) { item in
                VStack(alignment: .leading) {
                    Text(item.placemark.name ?? "")
                        .font(.headline)
                    Text(item.placemark.title ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    selectedResult = item
                    isShowingSearchSheet = false
                    
                    withAnimation {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: item.placemark.coordinate,
                            latitudinalMeters: 1000,
                            longitudinalMeters: 1000
                        ))
                    }
                }
            }
            .navigationTitle("Search Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Location Detail View
    private func locationDetailView(for mapItem: MKMapItem) -> some View {
        VStack(spacing: 16) {
            Text(mapItem.placemark.name ?? "Location")
                .font(.title2)
                .bold()
            
            if let address = mapItem.placemark.title {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 20) {
                Button {
                    calculateRoute(to: mapItem)
                } label: {
                    Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                
                Button {
                    mapItem.openInMaps()
                } label: {
                    Label("Open in Maps", systemImage: "map.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.indigo)
            }
            .padding(.top)
        }
        .padding()
    }
    
    // MARK: - Helper Functions
    private func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = .pointOfInterest
        
        if let location = locationManager.location {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 10000,
                longitudinalMeters: 10000
            )
        }
        
        Task {
            let search = MKLocalSearch(request: request)
            if let response = try? await search.start() {
                results = response.mapItems
                if !results.isEmpty {
                    isShowingSearchSheet = true
                }
            }
        }
    }
    
    private func calculateRoute(to destination: MKMapItem) {
        guard let location = locationManager.location else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        request.destination = destination
        
        Task {
            let directions = MKDirections(request: request)
            if let response = try? await directions.calculate() {
                route = response.routes.first
                
                if let route {
                    let rect = route.polyline.boundingMapRect
                    withAnimation {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 3.8480, longitude: 11.5021)  // Yaoundé, Cameroon coordinates
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(
            center: .userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000
        )
    }
}

extension MKMapItem: Identifiable {
    public var id: String {
        return "\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)"
    }
}

#Preview {
        ClientMapView()
}


