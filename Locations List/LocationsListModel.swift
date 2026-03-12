//
//  LocationsListModel.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import Foundation

@Observable
final class LocationsListModel {
    enum Status {
        case loading
        case success
        case failure(Error)
    }

    private(set) var locations: [Location] = []
    private(set) var fetchStatus: Status = .loading

    private let api: LocationsAPIProtocol

    init(api: LocationsAPIProtocol = LocationsAPI()) {
        self.api = api
    }

    func fetch() async {
        guard locations.isEmpty else { return }
        fetchStatus = .loading
        do {
            let locations = try await api.get()
            self.locations = locations
            fetchStatus = .success
        } catch {
            fetchStatus = .failure(error)
        }
    }
}
