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
    
    // We don't want to create a second Expenses here, but use the original Expenses from ContentView
//    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("What is the name of the person in the photo?")
                TextField("Michael Jackson", text: $personName)
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
//                        let item = ExpenseItem(name: name, type: type, amount: amount ?? 0.0)
//                        expenses.items.append(item)
//                        modelContext.insert(item)
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

//#Preview {
//    AddNameView()
//}
