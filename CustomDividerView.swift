//
//  CustomDividerView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 05/08/24.
//

import SwiftUI

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.gray.opacity(0.25))
            .padding(.vertical)
    }
}

#Preview {
    CustomDividerView()
}
