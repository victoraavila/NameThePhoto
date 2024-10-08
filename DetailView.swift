//
//  DetailView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 06/08/24.
//

import MapKit
import SwiftUI

struct DetailView: View {
    @Binding var profiles: [Profile]
    var profileName: String
    @Environment(\.dismiss) var dismiss
    
    @State private var cityName: String = "Unknownland"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let profile = profiles.first(where: { $0.name == profileName }) {
                    let photo = UIImage(data: profile.photo)
                    Image(uiImage: (photo ?? UIImage(named: "michael_jackson"))!)
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Image(systemName: "clock")
                            .fontWeight(.bold)
                            .symbolRenderingMode(.multicolor)
                        
                        Text("Taken at \(profile.createdAt.formatted())")
                            .italic()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "mappin")
                            .fontWeight(.bold)
                            .symbolRenderingMode(.multicolor)
                        
                        Text(cityName)
                            .italic()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    let position = MapCameraPosition.region(
                        MKCoordinateRegion(center: profile.location,
                                           span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                    )
                    
                    Map(initialPosition: position, interactionModes: []) {
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: profile.location.latitude + 0.075, longitude: profile.location.longitude)) {
                            Image(systemName: "mappin")
                                .font(.title)
                                .fontWeight(.bold)
                                .symbolRenderingMode(.multicolor)
                                .shadow(
                                        color: Color.black.opacity(0.8), // shadow color
                                        radius: 5, // shadow radius
                                        x: 0, // x offset
                                        y: 2 // y offset
                                    )
                        }
                    }
                        .frame(height: 200)
                    
                } else {
                    Text("Profile not found")
                        .font(.title)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    if let profile = profiles.first(where: { $0.name == profileName }) {
                        Text("\(profile.name)")
                            .font(.headline)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    deleteProfile()
                    dismiss()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            if let profile = profiles.first(where: {$0.name == profileName }) {
                fetchCityName(for: profile.location)
            }
        }
    }
    
    func fetchCityName(for location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                cityName = placemark.locality ?? "Unknownland 2"
            } else {
                cityName = "Unknownland 3"
            }
        }
    }
    
    func deleteProfile() {
        if let profileIndex = profiles.firstIndex(where: { $0.name == profileName }) {
            profiles.remove(at: profileIndex)
            saveHistory()
        }
    }
    
    func saveHistory() {
        do {
            let savePath = URL.documentsDirectory.appending(path: "SavedProfiles")
            let data = try JSONEncoder().encode(profiles)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save profiles.")
        }
    }
}

#Preview {
    DetailView(profiles: .constant([Profile(photo: UIImage(named: "michael_jackson")!.pngData()!,
                                            name: "Michael Jackson",
                                            createdAt: Date.now,
                                            location: CLLocationCoordinate2D(latitude: Double.random(in: -90...90), longitude: Double.random(in: -180...180)))]),
               profileName: "Michael Jackson")
}


