//
//  CustomLocationView.swift
//  Locations List
//
//  Created by Artem Kirienko on 11/03/2026.
//

import SwiftUI

struct CustomLocationView: View {
    private static let coordinateFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = false
        return formatter
    }()

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var latitude: Double?
    @State private var longitude: Double?

    private var latitudeIsValid: Bool {
        guard let latitude else { return false }
        return (-90...90).contains(latitude)
    }

    private var longitudeIsValid: Bool {
        guard let longitude else { return false }
        return (-180...180).contains(longitude)
    }

    private var canOpenLocation: Bool {
        latitudeIsValid && longitudeIsValid
    }

    private func coordinateValue(from text: String) -> Double? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return nil }
        return Self.coordinateFormatter.number(from: trimmedText)?.doubleValue
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Open a custom location")
                        .font(.title2.weight(.semibold))

                    Text("Enter coordinates to jump straight into Wikipedia Places.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 16) {
                    coordinateField(
                        title: "Latitude",
                        value: $latitude,
                        placeholder: "37.3346",
                        isValid: latitude == nil || latitudeIsValid,
                        helpText: "Use a value between -90 and 90."
                    )

                    coordinateField(
                        title: "Longitude",
                        value: $longitude,
                        placeholder: "-122.0090",
                        isValid: longitude == nil || longitudeIsValid,
                        helpText: "Use a value between -180 and 180."
                    )
                }

                Button {
                    guard let latitude, let longitude else { return }
                    openURL(Wikipedia.url(for: .init(name: nil, latitude: latitude, longitude: longitude)))
                    dismiss()
                } label: {
                    Text("Open in Wikipedia")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!canOpenLocation)

                Spacer()
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private func coordinateField(
        title: String,
        value: Binding<Double?>,
        placeholder: String,
        isValid: Bool,
        helpText: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            TextField(placeholder, value: value, formatter: Self.coordinateFormatter)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.numbersAndPunctuation)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isValid ? Color.secondary.opacity(0.2) : .red, lineWidth: 1)
                }

            Text(helpText)
                .font(.caption)
                .foregroundColor(isValid ? .secondary : .red)
        }
    }
}

#Preview {
    CustomLocationView()
}

