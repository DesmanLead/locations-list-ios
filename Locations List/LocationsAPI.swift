//
//  LocationsAPI.swift
//  Locations List
//
//  Created by Artem Kirienko on 11/03/2026.
//

import Foundation

nonisolated protocol LocationsAPIProtocol: Sendable {
    func get() async throws -> [Location]
}

final class LocationsAPI: LocationsAPIProtocol {
    private static let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!

    @concurrent func get() async throws -> [Location] {
        let request = URLRequest(url: Self.url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let collection = try JSONDecoder().decode(LocationsCollection.self, from: data)
        return collection.locations
    }
}

final class MockLocationsAPI: LocationsAPIProtocol {
    private let result: Result<[Location], Error>

    init(result: Result<[Location], Error> = .success([
        .init(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)
    ])) {
        self.result = result
    }

    func get() async throws -> [Location] {
        try result.get()
    }
}
