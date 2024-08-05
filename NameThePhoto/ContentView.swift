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
    
    var body: some View {
        VStack {
            PhotosPicker("Select a Photo", selection: $selectedPhoto)
                .onChange(of: selectedPhoto, loadImage)
            
            Spacer()
            
            List {
                loadedPhoto?
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
        }
        .sheet(isPresented: $askForName) {
            AddNameView(loadedPhoto: $loadedPhoto)
        }
    }
    
    func loadImage() {
        Task {
            loadedPhoto = try await selectedPhoto?.loadTransferable(type: Image.self)
        }
        
        askForName = true
    }
}

#Preview {
    ContentView()
}
