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
                        
                        Text("Uberlândia, Minas Gerais, Brazil") //
                            .italic()
                    }
                    
                    let position = MapCameraPosition.region(
                        MKCoordinateRegion(center: profile.location,
                                           span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                    )
                    
                    Map(initialPosition: position, interactionModes: [])
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


