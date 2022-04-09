//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Paul Hudson on 18/01/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")

    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    @State private var showingConfirmationDialog = false
    @State private var order = SortingOrder.no
    
    var body: some View {
        NavigationView {
            List(sortedFilteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }

                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                Button {
                    showingConfirmationDialog = true
                }
                label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
            }
            .confirmationDialog("Order", isPresented: $showingConfirmationDialog) {
                Button(action: { order = SortingOrder.no }) {
                    Text("Default")
                }
                Button(action: { order = SortingOrder.alphabetical }) {
                    Text("Alphabetical")
                }
                Button(action: { order = SortingOrder.country }) {
                    Text("Country")
                }
            }
            WelcomeView()
        }
        .environmentObject(favorites)

    }

    var sortedFilteredResorts: [Resort] {
        switch order {
        case .no:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { resortA, resortB in
                resortA.name < resortB.name
            }
        case .country:
            return filteredResorts.sorted { resortA, resortB in
                resortA.country < resortB.country
            }
        }
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    enum SortingOrder {
        case no
        case alphabetical
        case country
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
