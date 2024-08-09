//
//  Profile.swift
//  NameThePhoto
//
//  Created by Víctor Ávila on 05/08/24.
//

import CoreLocation
import Foundation
import SwiftUI

struct Profile: Codable, Identifiable {
    let photo: Data
    let name: String
    let createdAt: Date
    let location: CLLocationCoordinate2D
    
    var id: String {
        name
    }
    
    enum CodingKeys: String, CodingKey {
        case photo, name, createdAt, location
    }
    
    private enum LocationCodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    init(photo: Data, name: String, createdAt: Date, location: CLLocationCoordinate2D) {
        self.photo = photo
        self.name = name
        self.createdAt = createdAt
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        photo = try container.decode(Data.self, forKey: .photo)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        let locationContainer = try container.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        let latitude = try locationContainer.decode(Double.self, forKey: .latitude)
        let longitude = try locationContainer.decode(Double.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(photo, forKey: .photo)
        try container.encode(name, forKey: .name)
        try container.encode(createdAt, forKey: .createdAt)
        
        var locationContainer = container.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        try locationContainer.encode(location.latitude, forKey: .latitude)
        try locationContainer.encode(location.longitude, forKey: .longitude)
    }
}
