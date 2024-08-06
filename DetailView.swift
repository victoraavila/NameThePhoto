//
//  DetailView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 06/08/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var profiles: [Profile]
    var profileIndex: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            if profiles.count > 0 {
                let profile = profiles[profileIndex]
                let photo = UIImage(data: profile.photo)
                Image(uiImage: (photo ?? UIImage(named: "michael_jackson"))!)
                    .resizable()
                    .scaledToFit()
                
                Text(profile.name)
                    .font(.title)
                
                Text("(Photo taken at \(profile.createdAt.formatted()))")
                    .italic()
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Delete profile", systemImage: "trash", role: .destructive) {
                    deleteProfile()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func deleteProfile() {
        profiles.remove(at: profileIndex)
        saveHistory()
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
               profileIndex: 0)
}
