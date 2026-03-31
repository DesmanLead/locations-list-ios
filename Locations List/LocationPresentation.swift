//
//  LocationPresentation.swift
//  Locations List
//
//  Created by Artem Kirienko on 12/03/2026.
//

import Foundation

extension Location {
    var displayName: String {
        guard let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmedName.isEmpty else {
            return "Unnamed location"
        }

        return trimmedName
    }

    var hasCustomName: Bool {
        guard let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }

        return !trimmedName.isEmpty
    }

    var coordinatesText: String {
        "\(latitude), \(longitude)"
    }

    var wikipediaURL: URL {
        Wikipedia.url(for: self)
    }
}
