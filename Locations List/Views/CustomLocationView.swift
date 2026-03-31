//
//  CustomLocationView.swift
//  Locations List
//
//  Created by Artem Kirienko on 11/03/2026.
//

import SwiftUI

struct CustomLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var model = CustomLocationModel()

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
                        value: $model.latitudeText,
                        placeholder: "37.3346",
                        validation: model.latitudeValidation,
                        helpText: "Use a value between -90 and 90."
                    )

                    coordinateField(
                        title: "Longitude",
                        value: $model.longitudeText,
                        placeholder: "-122.0090",
                        validation: model.longitudeValidation,
                        helpText: "Use a value between -180 and 180."
                    )
                }

                Button {
                    guard let location = model.location() else { return }
                    openURL(location.wikipediaURL)
                    dismiss()
                } label: {
                    Text("Open in Wikipedia")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!model.canOpenLocation)

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
        value: Binding<String>,
        placeholder: String,
        validation: CustomLocationModel.ValidationStatus,
        helpText: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            TextField(placeholder, text: value)
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
                        .stroke(validation.showsError ? .red : Color.secondary.opacity(0.2), lineWidth: 1)
                }

            Text(helpText)
                .font(.caption)
                .foregroundColor(validation.showsError ? .red : .secondary)
        }
    }
}

#Preview {
    CustomLocationView()
}
