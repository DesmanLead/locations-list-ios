//
//  LocationsCollection.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import Foundation

nonisolated struct LocationsCollection: Codable, Sendable {
    let locations: [Location]
}
