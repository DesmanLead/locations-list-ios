//
//  Locations_ListTests.swift
//  Locations ListTests
//
//  Created by Artem Kirienko on 10/03/2026.
//

import Testing
@testable import LocationsList

@Suite struct LocationsListModelTests {

    @MainActor @Test func fetchesLocations() async throws {
        let sut = LocationsListModel()
        await sut.fetch()
        #expect(!sut.locations.isEmpty)
    }

}
