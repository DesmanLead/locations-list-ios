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

    private var locationName: String? {
        guard let name = model.name?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else {
            return nil
        }
        return name
    }

    private var coordinatesText: String {
        "\(model.latitude), \(model.longitude)"
    }

    var body: some View {
        Button {
            let url = Wikipedia.url(for: model)
            openURL(url)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(locationName ?? "Unnamed location")
                    .font(.headline)
                    .foregroundStyle(locationName == nil ? .secondary : .primary)

                Text(coordinatesText)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(locationName ?? "Unnamed location")
        .accessibilityValue("Coordinates \(coordinatesText)")
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

