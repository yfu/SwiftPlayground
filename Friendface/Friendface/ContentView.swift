//
//  ContentView.swift
//  Friendface
//
//  Created by Yu Fu on 2/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default) private var cachedUsers: FetchedResults<CachedUser>
        
    @State private var users: [User] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    HStack {
                        NavigationLink(destination: UserView(id: user.id, users: users)) {
                            HStack {
                                Text("\(user.name)@\(user.age)")
                                Spacer()
                                Circle().foregroundColor(user.isActive ? .green : .red).frame(width: 10, height: 10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("People")
            .task {
                await loadData()
            }
        }
        
    }
    
    func loadData() async {
        if !users.isEmpty {
            print("Data already loaded")
            return
        }

        // Good URL
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
        // Bad URL for testing
        // guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json.bad.url") else {
            print("Invalid URL!")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            users = try decoder.decode([User].self, from: data)
            
            users.forEach { user in
                let cachedUser = CachedUser(context: viewContext)
                cachedUser.id = user.id
                cachedUser.isActive = user.isActive
                cachedUser.unWrappedName = user.name
                cachedUser.age = Int16(user.age)
                cachedUser.unWrappedCompany = user.company
                cachedUser.unWrappedEmail = user.email
                cachedUser.unWrappedAddress = user.address
                cachedUser.unWrappedAbout = user.about
                cachedUser.unWrappedRegistered = user.registered
                cachedUser.unWrappedTags = user.tags
                cachedUser.unWrappedFriendUUIDs = user.friends.map { $0.id }
            }
        } catch {
            print("Error loading data from URL. Will load from Core Data")
            var idToName: Dictionary<UUID, String> = [:]
            // Here we go through cachedUsers twice, to establish the mapping from id to name and then to make actual User objects
            cachedUsers.forEach { cachedUser in
                idToName[cachedUser.unWrappedID] = cachedUser.name
            }
            
            cachedUsers.forEach { cachedUser in
                var user = User(id: cachedUser.unWrappedID, isActive: cachedUser.isActive, name: cachedUser.unWrappedName,
                                age: Int(cachedUser.age), company: cachedUser.unWrappedCompany,
                                email: cachedUser.unWrappedEmail, address: cachedUser.unWrappedAddress,
                                about: cachedUser.unWrappedAbout, registered: cachedUser.unWrappedRegistered,
                                tags: cachedUser.unWrappedTags)
                cachedUser.unWrappedFriendUUIDs.forEach { friendUUID in
                    user.friends.append(
                        Friend(id: friendUUID, name: idToName[friendUUID] ?? "Friend with no name"))
                }
                users.append(user)
            }
            
        }
        
        do {
            if viewContext.hasChanges {
                try viewContext.save()
                print("Done saving to Core Data")
            }
        } catch {
            print("Error saving objects to Core Data")
            print(error)
        }
    }
    //    var body: some View {
    //        NavigationView {
    //            List {
    //                ForEach(items) { item in
    //                    NavigationLink {
    //                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
    //                    } label: {
    //                        Text(item.timestamp!, formatter: itemFormatter)
    //                    }
    //                }
    //                .onDelete(perform: deleteItems)
    //            }
    //            .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    EditButton()
    //                }
    //                ToolbarItem {
    //                    Button(action: addItem) {
    //                        Label("Add Item", systemImage: "plus")
    //                    }
    //                }
    //            }
    //            Text("Select an item")
    //        }
    //    }
    //
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
