//
//  DetailView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 06/08/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var profiles: [Profile]
    var profileName: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let profile = profiles.first(where: { $0.name == profileName }) {
                    let photo = UIImage(data: profile.photo)
                    Image(uiImage: (photo ?? UIImage(named: "michael_jackson"))!)
                        .resizable()
                        .scaledToFit()
                    
                    Text(profile.name)
                        .font(.title)
                    
                    Text("(Photo taken at \(profile.createdAt.formatted()))")
                        .italic()
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
                    Text("Profile Details")
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    deleteProfile()
                    presentationMode.wrappedValue.dismiss()
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
                                            createdAt: Date.now)]),
               profileName: "Michael Jackson")
}


