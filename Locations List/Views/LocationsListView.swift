//
//  LocationsListView.swift
//  Locations List
//
//  Created by Artem Kirienko on 12/03/2026.
//

import SwiftUI

struct LocationsListView: View {
    let locations: [Location]

    var body: some View {
        List {
            Section {
                ForEach(locations) { location in
                    LocationCell(model: location)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}
