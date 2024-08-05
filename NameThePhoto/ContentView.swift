//
//  ContentView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 04/08/24.
//

//import CoreImage
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var askForName = false
    @State private var loadedPhoto: Image?
    @State private var profiles = [Profile]()
    
    var body: some View {
        ScrollView {
            if !askForName {
                let recentProfiles = getMostRecentProfiles()
                ForEach(recentProfiles) { profile in
                    HStack {
                        profile.photo
                            .resizable()
                            .scaledToFit()
                            .clipShape(.circle)
                            .frame(width: 250)
                        
                        Spacer()
                        
                        Text(profile.name)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
            
        PhotosPicker("Select a Photo", selection: $selectedPhoto)
            .onChange(of: selectedPhoto, loadImage)
            
        
        .sheet(isPresented: $askForName) {
            AddNameView(loadedPhoto: $loadedPhoto, profiles: $profiles)
        }
    }
    
    func loadImage() {
        Task {
            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                loadedPhoto = image
                askForName = true
            }
        }
    }
    
    func getMostRecentProfiles() -> [Profile] {
        // Dictionary to hold the most recent profile for each name
        var recentProfilesDict = [String: Profile]()
        
        for profile in profiles {
            if let existingProfile = recentProfilesDict[profile.name] {
                if profile.createdAt > existingProfile.createdAt {
                    recentProfilesDict[profile.name] = profile
                }
            } else {
                recentProfilesDict[profile.name] = profile
            }
        }
        
        return Array(recentProfilesDict.values)
    }
    
}

#Preview {
    ContentView()
}
