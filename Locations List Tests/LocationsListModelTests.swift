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
    private final class LocationsAPISpy: LocationsAPIProtocol, @unchecked Sendable {
        private(set) var getCallCount = 0

        private let result: Result<[Location], Error>

        init(result: Result<[Location], Error>) {
            self.result = result
        }

        func get() async throws -> [Location] {
            getCallCount += 1
            return try result.get()
        }
    }

    @Test func startsInLoadingState() {
        let sut = LocationsListModel(api: MockLocationsAPI(result: .success([])))

        #expect(sut.locations.isEmpty)
        guard case .loading = sut.fetchStatus else {
            Issue.record("Expected initial fetchStatus to be .loading, got \(sut.fetchStatus)")
            return
        }
    }

    @Test func handlesSuccessfulFetch() async throws {
        let locations = [Location(name: "Test Location", latitude: 0, longitude: 0)]
        let api = LocationsAPISpy(result: .success(locations))
        let sut = LocationsListModel(api: api)

        await sut.fetch()

        guard case .success = sut.fetchStatus else {
            Issue.record("Expected fetchStatus to be .success, got \(sut.fetchStatus)")
            return
        }

        #expect(sut.locations.count == locations.count)
        #expect(api.getCallCount == 1)
    }

    @Test func handlesFailedFetch() async throws {
        let error = NSError(domain: "TestError", code: 42)
        let api = LocationsAPISpy(result: .failure(error))
        let sut = LocationsListModel(api: api)

        await sut.fetch()

        guard case .failure(let fetchError) = sut.fetchStatus else {
            Issue.record("Expected fetchStatus to be .failure, got \(sut.fetchStatus)")
            return
        }

        #expect(fetchError.localizedDescription == error.localizedDescription)
        #expect(api.getCallCount == 1)
    }

    @Test func doesNotRefetchAfterSuccessfulLoad() async throws {
        let api = LocationsAPISpy(result: .success([
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)
        ]))
        let sut = LocationsListModel(api: api)

        await sut.fetch()
        await sut.fetch()

        #expect(api.getCallCount == 1)
    }

    @Test func retriesAfterFailureBecauseNoDataWasLoaded() async throws {
        let error = NSError(domain: "TestError", code: 42)
        let api = LocationsAPISpy(result: .failure(error))
        let sut = LocationsListModel(api: api)

        await sut.fetch()
        await sut.fetch()

        #expect(api.getCallCount == 2)
    }
}
