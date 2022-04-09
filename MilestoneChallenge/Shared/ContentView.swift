//
//  ContentView.swift
//  Shared
//
//  Created by Yu Fu on 4/2/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var dice = Dice()
    @State private var showingConfigView = false
    @State private var isFlickering = false
    @State private var flickerCounter = 0
    let generator = UINotificationFeedbackGenerator()
    
    var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                DiceView(dice: $dice, isFlickering: isFlickering)
                Spacer()
                HStack {
                    Button(action: { onRollDice() }) {
                        Text("Roll")
                    }
                    .buttonStyle(.borderedProminent)
                    .onTapGesture {
                        generator.notificationOccurred(.success)
                    }
                    Spacer()
                    Button(role: .destructive) {
                        dice.reset()
                    } label: {
                        Text("Reset")
                    }
                }
            }
            .navigationTitle("\(dice.sides)-sided dice")
            .toolbar {
                Button(action: { showingConfigView.toggle() }) {
                    Image(systemName: "gearshape")
                }
            }
            .sheet(isPresented: $showingConfigView) {
                ConfigView(dice: $dice)
            }
            .onChange(of: dice) { _ in
                saveDice()
            }
            .onReceive(timer) { _ in
                if flickerCounter == 5 {
                    flickerCounter = 0
                    dice.roll()
                    isFlickering = false
                }
                if isFlickering {
                    dice.flicker()
                    flickerCounter += 1
                }
            }
            .onAppear {
                generator.prepare()
            }

        }
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
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
    }
    
    private func onRollDice() {
        isFlickering = true
        flickerCounter = 0
    }
    
    private func saveDice() {
        dice.save()
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
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
