//
//  LocationPresentationTests.swift
//  Locations List Tests
//
//  Created by Artem Kirienko on 12/03/2026.
//

import Foundation
import Testing
@testable import LocationsList

@Suite struct LocationPresentationTests {
    @Test func trimsLocationNameForDisplay() {
        let location = Location(name: "  Amsterdam  ", latitude: 52.3547498, longitude: 4.8339215)

        #expect(location.displayName == "Amsterdam")
        #expect(location.hasCustomName)
    }

    @Test func fallsBackWhenLocationNameIsMissing() {
        let location = Location(name: "   ", latitude: 52.3547498, longitude: 4.8339215)

        #expect(location.displayName == "Unnamed location")
        #expect(!location.hasCustomName)
    }

    @Test func exposesCoordinatesAndWikipediaURL() {
        let location = Location(name: nil, latitude: 52.3547498, longitude: 4.8339215)

        #expect(location.coordinatesText == "52.3547498, 4.8339215")
        #expect(location.wikipediaURL.absoluteString == "wikipedia://places?lat=52.3547498&lon=4.8339215")
    }
}
