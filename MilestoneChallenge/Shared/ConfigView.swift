//
//  ConfigView.swift
//  MilestoneChallenge
//
//  Created by Yu Fu on 4/2/22.
//

import SwiftUI

struct ConfigView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var dice: Dice    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Picker("Dice sides", selection: $dice.sides) {
                        ForEach(1..<101) { s in
                            Text("\(s)").tag(s)
                        }
                    }
                }
                Button(action: { dismiss() }) {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Dice Preferences")
    }
}

//struct ConfigView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfigView(6) { _ in
//            // Do nothing
//        }
//    }
//}
