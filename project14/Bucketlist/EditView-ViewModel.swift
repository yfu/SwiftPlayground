//
//  EditView-ViewModel.swift
//  Bucketlist
//
//  Created by Yu Fu on 2/21/22.
//

import Foundation

extension EditView {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @MainActor class ViewModel: ObservableObject {
        var location: Location

        @Published var name: String
        @Published var description: String
        @Published private(set) var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        
        init(location: Location) {
            self.location = location
            self.name = self.location.name
            self.description = self.location.description
        }
        
        func changeLoadingState(to newLoadingState: LoadingState) {
            Task { @MainActor in
                self.loadingState = newLoadingState
            }
        }
        
        var updatedLocation: Location {
            Location(id: UUID(), name: self.name, description: self.description, latitude: self.location.latitude, longitude: self.location.longitude)
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                self.pages = items.query.pages.values.sorted()
                // loadingState = .loaded
                self.changeLoadingState(to: .loaded)
            } catch {
                // loadingState = .failed
                self.changeLoadingState(to: .failed)
            }
        }
    }
}
