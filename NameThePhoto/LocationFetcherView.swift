//
//  LocationFetcherView.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 08/08/24.
//

import SwiftUI

struct LocationFetcherView: View {
    let locationFetcher = LocationFetcher()

    var body: some View {
        VStack {
            Button("Start Tracking Location") {
                locationFetcher.start()
            }

            Button("Read Location") {
                if let location = locationFetcher.lastKnownLocation {
                    print("Your location is \(location)")
                } else {
                    print("Your location is unknown")
                }
            }
        }
    }
}

#Preview {
    LocationFetcherView()
}
