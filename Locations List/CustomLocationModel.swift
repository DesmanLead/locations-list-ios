//
//  CustomLocationModel.swift
//  Locations List
//
//  Created by Artem Kirienko on 12/03/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class CustomLocationModel {
    enum ValidationStatus: Equatable {
        case empty
        case valid
        case invalid

        var showsError: Bool {
            self == .invalid
        }
    }

    private static let coordinateFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = false
        return formatter
    }()

    var latitudeText = ""
    var longitudeText = ""

    var latitudeValidation: ValidationStatus {
        validationStatus(for: latitudeText, validRange: -90...90)
    }

    var longitudeValidation: ValidationStatus {
        validationStatus(for: longitudeText, validRange: -180...180)
    }

    var canOpenLocation: Bool {
        latitudeValidation == .valid && longitudeValidation == .valid
    }

    func location() -> Location? {
        guard let latitude = validCoordinate(from: latitudeText, in: -90...90),
              let longitude = validCoordinate(from: longitudeText, in: -180...180) else {
            return nil
        }

        return Location(name: nil, latitude: latitude, longitude: longitude)
    }

    private func validationStatus(for text: String, validRange: ClosedRange<Double>) -> ValidationStatus {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            return .empty
        }

        guard let value = Self.coordinateFormatter.number(from: trimmedText)?.doubleValue,
              validRange.contains(value) else {
            return .invalid
        }

        return .valid
    }

    private func validCoordinate(from text: String, in validRange: ClosedRange<Double>) -> Double? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty,
              let value = Self.coordinateFormatter.number(from: trimmedText)?.doubleValue,
              validRange.contains(value) else {
            return nil
        }

        return value
    }
}
