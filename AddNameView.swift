//
//  AddNameView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 05/08/24.
//

import SwiftUI

struct AddNameView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var loadedPhoto: Image?
    @Binding var loadedPhotoData: Data
    @Binding var profiles: [Profile]
    
    @State private var personName = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if let loadedPhoto = loadedPhoto {
                    loadedPhoto
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical)
                }
                Text("What is the name of the person in the photo?")
                TextField("e.g., Michael Jackson", text: $personName)
                    .padding(.horizontal, 25)
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if loadedPhoto != nil {
                            let newProfile = Profile(photo: loadedPhotoData, name: personName, createdAt: Date.now)
                            profiles.append(newProfile)
                            saveHistory()
                        }
                        dismiss()
                    }
                }
            }
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
    AddNameView(loadedPhoto: .constant(Image("michael_jackson")),
                loadedPhotoData: .constant(UIImage(named: "michael_jackson")!.pngData()!),
                profiles: .constant([Profile]()))
}
