//
//  LocationsListSkeletonView.swift
//  Locations List
//
//  Created by Artem Kirienko on 12/03/2026.
//

import SwiftUI

struct LocationsListSkeletonView: View {
    var body: some View {
        LocationsListView(locations: [
            .init(name: "Amsterdam", latitude: 0, longitude: 0),
            .init(name: "Haarlem", latitude: 0, longitude: 0),
            .init(name: "Lisboa", latitude: 0, longitude: 0),
            .init(name: "Funchal", latitude: 0, longitude: 0),
        ])
        .redacted(reason: .placeholder)
        .accessibilityHidden(true)
    }
}

#Preview {
    LocationsListSkeletonView()
}
