//
//  LocationCell.swift
//  Locations List
//
//  Created by Artem Kirienko on 11/03/2026.
//

import SwiftUI

struct LocationCell: View {
    @Environment(\.openURL) private var openURL

    let model: Location

    var body: some View {
        Button {
            openURL(model.wikipediaURL)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.displayName)
                    .font(.headline)
                    .foregroundStyle(model.hasCustomName ? .primary : .secondary)

                Text(model.coordinatesText)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(model.displayName)
        .accessibilityValue("Coordinates \(model.coordinatesText)")
        .accessibilityHint("Opens this location in Wikipedia")
    }
}

#Preview {
    List {
        LocationCell(model: .init(name: "Cupertino", latitude: 37.3229, longitude: -122.0322))
        LocationCell(model: .init(name: nil, latitude: 48.8584, longitude: 2.2945))
    }
    .listStyle(.plain)
}
