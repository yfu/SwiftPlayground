//
//  UserView.swift
//  Friendface
//
//  Created by Yu Fu on 2/17/22.
//

import SwiftUI

struct UserView: View {
    var id: UUID
    var users: [User]
    
    var user: User {
        get_user(uuid: id, users: users)!
    }
    
    var body: some View {
        VStack {
            List {
                Section("Information") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(user.name)
                    }
                    HStack {
                        Text("Age")
                        Spacer()
                        Text(user.age, format: .number)
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        Circle().foregroundColor(user.isActive ? .green : .red).frame(maxWidth: 10,  maxHeight: 10)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(user.email)
                    }
                    HStack {
                        Text("Company")
                        Spacer()
                        Text(user.company)
                    }
                    HStack {
                        Text("Address")
                        Spacer()
                        Text(user.address)
                    }
                    HStack {
                        Text("Registration date")
                        Spacer()
                        Text(user.registered, format: .iso8601)
                    }
                }
                
                Section("Friends") {
                    ForEach(user.friends) { friend in
                        NavigationLink(destination: UserView(id: friend.id, users: users)) {
                            Text(friend.name)
                        }
                    }
                }
                
                Section("About") {
                    Text(user.about)
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func get_user(uuid: UUID, users: [User]) -> User? {
        return users.first { user in
            user.id == uuid
        }
    }
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
