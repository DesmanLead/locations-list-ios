//
//  LocationsListView.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import SwiftUI

struct LocationsListView: View {
    let model: LocationsListModel

    @State private var isCustomLocationViewPresented = false

    var body: some View {
        NavigationStack {
            Group {
                if let error = model.fetchError {
                    ContentUnavailableView {
                        Label("Failed to load locations", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error.localizedDescription)
                    }
                    .accessibilityAddTraits(.isStaticText)
                } else if model.locations.isEmpty {
                    ContentUnavailableView(
                        "No Locations",
                        systemImage: "map",
                        description: Text("You can still open a custom location by entering coordinates manually.")
                    )
                    .accessibilityAddTraits(.isStaticText)
                } else {
                    List {
                        Section {
                            ForEach(model.locations) { location in
                                LocationCell(model: location)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color.accentColor.opacity(0.10),
                        Color(uiColor: .systemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .navigationTitle("Locations")
        }
        .task {
            await model.fetch()
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                isCustomLocationViewPresented = true
            } label: {
                Label("Custom Coordinates", systemImage: "location.viewfinder")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.top, 12)
            .background(.bar)
            .accessibilityHint("Opens a form to enter a custom latitude and longitude")
        }
        .sheet(isPresented: $isCustomLocationViewPresented) {
            CustomLocationView()
        }
    }
}

#Preview {
    LocationsListView(model: .init(api: MockLocationsAPI()))
}

#Preview("Empty") {
    LocationsListView(model: .init(api: MockLocationsAPI(result: .success([]))))
}

#Preview("Error") {
    LocationsListView(model: .init(api: MockLocationsAPI(result: .failure(NSError(domain: "test", code: 42)))))
}
