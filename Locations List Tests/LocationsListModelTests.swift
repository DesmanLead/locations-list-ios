//
//  Locations_ListTests.swift
//  Locations ListTests
//
//  Created by Artem Kirienko on 10/03/2026.
//

import Foundation
import Testing
@testable import LocationsList

@MainActor
@Suite struct LocationsListModelTests {

    @Test func fetchesLocations() async throws {
        let sut = LocationsListModel()
        await sut.fetch()
        #expect(!sut.locations.isEmpty)
    }

    @Test func handlesSuccessfulFetch() async throws {
        let locations = [Location(name: "Test Location", latitude: 0, longitude: 0)]
        let sut = LocationsListModel(api: MockLocationsAPI(result: .success(locations)))
        await sut.fetch()
        guard case .success = sut.fetchStatus else {
            Issue.record("Expected fetchStatus to be .success, got \(sut.fetchStatus)")
            return
        }
        #expect(sut.locations.count == locations.count)
    }

    @Test func handlesFailedFetch() async throws {
        let error = NSError(domain: "TestError", code: 42)
        let sut = LocationsListModel(api: MockLocationsAPI(result: .failure(error)))
        await sut.fetch()
        guard case .failure(let fetchError) = sut.fetchStatus else {
            Issue.record("Expected fetchStatus to be .failure, got \(sut.fetchStatus)")
            return
        }
        #expect(fetchError.localizedDescription == error.localizedDescription)
    }

}
