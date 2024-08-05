//
//  AddNameView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 05/08/24.
//

import SwiftUI

struct AddNameView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "Expense Name"
    @Binding var loadedPhoto: Image?
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
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddNameView(loadedPhoto: .constant(Image("michael_jackson")))
}
