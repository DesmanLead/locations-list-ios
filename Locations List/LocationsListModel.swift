//
//  LocationsListModel.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import Foundation

@Observable
final class LocationsListModel {
    private(set) var locations: [Location] = []
    private(set) var fetchError: Error?

    private let api: LocationsAPIProtocol

    init(api: LocationsAPIProtocol = LocationsAPI()) {
        self.api = api
    }

    func fetch() async {
        guard locations.isEmpty else { return }
        do {
            let locations = try await api.get()
            self.locations = locations
        } catch {
            fetchError = error
        }
    }
}
