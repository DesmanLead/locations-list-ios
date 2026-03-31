//
//  CustomLocationModelTests.swift
//  Locations List Tests
//
//  Created by Artem Kirienko on 12/03/2026.
//

import Testing
@testable import LocationsList

@MainActor
@Suite struct CustomLocationModelTests {
    @Test func keepsEmptyFieldsNeutral() {
        let sut = CustomLocationModel()

        #expect(sut.latitudeValidation == .empty)
        #expect(sut.longitudeValidation == .empty)
        #expect(!sut.canOpenLocation)
        #expect(sut.location() == nil)
    }

    @Test func parsesTrimmedCoordinatesIntoLocation() {
        let sut = CustomLocationModel()
        sut.latitudeText = " 37.3346 "
        sut.longitudeText = " -122.0090 "

        let location = sut.location()

        #expect(sut.latitudeValidation == .valid)
        #expect(sut.longitudeValidation == .valid)
        #expect(sut.canOpenLocation)
        #expect(location?.latitude == 37.3346)
        #expect(location?.longitude == -122.0090)
    }

    @Test func rejectsInvalidLatitudeAndLongitude() {
        let sut = CustomLocationModel()
        sut.latitudeText = "91"
        sut.longitudeText = "west"

        #expect(sut.latitudeValidation == .invalid)
        #expect(sut.longitudeValidation == .invalid)
        #expect(!sut.canOpenLocation)
        #expect(sut.location() == nil)
    }
}
