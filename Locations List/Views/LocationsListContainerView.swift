//
//  LocationsListContainerView.swift
//  Locations List
//
//  Created by Artem Kirienko on 10/03/2026.
//

import SwiftUI

struct LocationsListContainerView: View {
    let model: LocationsListModel

    @State private var isCustomLocationViewPresented = false

    var body: some View {
        NavigationStack {
            Group {
                switch model.fetchStatus {
                    case .loading:
                        LocationsListSkeletonView()
                    case .success:
                        if model.locations.isEmpty {
                            ContentUnavailableView {
                                Label("No Locations", systemImage: "map")
                            } description: {
                                Text("You can still open a custom location by entering coordinates manually.")
                            }
                            .accessibilityAddTraits(.isStaticText)
                        } else {
                            LocationsListView(locations: model.locations)
                        }
                    case .failure(let error):
                        ContentUnavailableView {
                            Label("Failed to load locations", systemImage: "exclamationmark.triangle")
                        } description: {
                            Text(error.localizedDescription)
                        }
                        .accessibilityAddTraits(.isStaticText)
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
    LocationsListContainerView(model: .init(api: MockLocationsAPI()))
}

#Preview("Empty") {
    LocationsListContainerView(model: .init(api: MockLocationsAPI(result: .success([]))))
}

#Preview("Error") {
    LocationsListContainerView(model: .init(api: MockLocationsAPI(result: .failure(NSError(domain: "test", code: 42)))))
}
