//
//  Location.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import Foundation

nonisolated struct Location: Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }

    let name: String?
    let latitude: Double
    let longitude: Double
}

extension Location: Identifiable {
    var id: String { "\(latitude)-\(longitude)" }
}
