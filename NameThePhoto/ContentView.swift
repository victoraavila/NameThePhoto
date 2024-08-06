//
//  ContentView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 04/08/24.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var askForName = false
    @State private var loadedPhotoData = Data()
    @State private var loadedPhoto: Image?
    @State private var profiles = [Profile]()
    
    let savePath = URL.documentsDirectory.appending(path: "SavedProfiles")
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if !askForName {
                        let recentProfiles = getMostRecentProfiles()
                        ForEach(recentProfiles.indices, id: \.self) { index in
                            let profile = recentProfiles[index]
                            NavigationLink(destination: DetailView(profiles: $profiles, profileName: profile.name)) {
                                HStack {
                                    let photo = UIImage(data: profile.photo)
                                    Image(uiImage: (photo ?? UIImage(named: "michael_jackson"))!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 200, height: 200)
                                        .clipped()
                                    
                                    Spacer()
                                    
                                    Text(profile.name)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            
                            
                            if index < recentProfiles.count - 1 {
                                CustomDividerView()
                            }
                        }
                    }
                    
                    Spacer()
                }
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    VStack {
                        Image(systemName: "photo.badge.plus")
                            .padding(5)
                            .font(.title)
                        Text("Tap to add a new person")
                            
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                }
                    .onChange(of: selectedPhoto) { _, newItem in
                        if let newItem = newItem {
                            loadImage(newItem: newItem)
                        }
                    }
            }
            .task {
                loadHistory()
            }
            .sheet(isPresented: $askForName) {
                AddNameView(loadedPhoto: $loadedPhoto, loadedPhotoData: $loadedPhotoData, profiles: $profiles)
            }
        }
    }
    
    func loadHistory() {
        do {
            let data = try Data(contentsOf: savePath)
            profiles = try JSONDecoder().decode([Profile].self, from: data)
        } catch {
            profiles = []
        }
    }
    
    func loadImage(newItem: PhotosPickerItem) {
        Task {
            if let loadedPhotoData = try await newItem.loadTransferable(type: Data.self) {
                self.loadedPhotoData = loadedPhotoData
                if let uiImage = UIImage(data: loadedPhotoData) {
                    loadedPhoto = Image(uiImage: uiImage)
                }
                askForName = true
                selectedPhoto = nil
            }
        }
    }
    
    func getMostRecentProfiles() -> [Profile] {
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
        
        let recentProfiles = Array(recentProfilesDict.values)
        let sortedProfiles = recentProfiles.sorted { $0.name < $1.name }
        return sortedProfiles
    }
}

#Preview {
    ContentView()
}

