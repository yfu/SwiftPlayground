//
//  EditView.swift
//  Bucketlist
//
//  Created by Paul Hudson on 09/12/2021.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    // It accepts a Location object and immediately pass it to the
    // ViewModel object in the initializer.
    var location: Location
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }

                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.updatedLocation
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }


}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
