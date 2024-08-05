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
    @Binding var profiles: [Profile]
    
    @State private var personName = ""
    
    let types = ["Business", "Personal"]
    
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
                TextField("Michael Jackson", text: $personName)
                    .padding(.horizontal, 25)
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let loadedPhoto = loadedPhoto {
                            let newProfile = Profile(photo: loadedPhoto, name: personName, createdAt: Date.now)
                            profiles.append(newProfile)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddNameView(loadedPhoto: .constant(Image("michael_jackson")), profiles: .constant([Profile]()))
}
