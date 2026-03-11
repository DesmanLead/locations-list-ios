//
//  Locations_ListApp.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import SwiftUI

@main
struct LocationsListApp: App {
    @State private var locationsListModel = LocationsListModel()

    var body: some Scene {
        WindowGroup {
            LocationsListView(model: locationsListModel)
        }
    }
}
