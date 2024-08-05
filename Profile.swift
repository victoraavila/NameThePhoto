//
//  Profile.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 05/08/24.
//

import Foundation
import SwiftUI

struct Profile: Identifiable {
    let photo: Image
    let name: String
    let createdAt: Date
    
    var id: String {
        name
    }
}
