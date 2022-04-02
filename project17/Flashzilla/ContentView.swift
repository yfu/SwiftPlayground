//
//  ContentView.swift
//  Flashzilla
//
//  Created by Paul Hudson on 07/01/2022.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards = [Card]() // Array(repeating: Card.example, count: 5)

    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true

    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .onTapGesture {
                    print(cards)
                }

            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())

                ZStack {
                    ForEach(cards) { card in
                        let index = cards.firstIndex(of: card)!
                        CardView(card: cards[index], onCorrectAnswer: {
                            withAnimation {
                                onCorrectAnswer(cardAt: index)
                            }
                        }, onWrongAnswer: {
                            withAnimation {
                                onWrongAnswer(cardAt: index)
                            }
                        })
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }

            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()

            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
//                        Button {
//                            withAnimation {
//                                removeCard(at: cards.count - 1)
//                            }
//                        } label: {
//                            Image(systemName: "xmark.circle")
//                                .padding()
//                                .background(.black.opacity(0.7))
//                                .clipShape(Circle())
//                        }
//                        .accessibilityLabel("Wrong")
//                        .accessibilityHint("Mark your answer as being incorrect")
//
                        Spacer()
//
//                        Button {
//                            withAnimation {
//                                removeCard(at: cards.count - 1)
//                            }
//                        } label: {
//                            Image(systemName: "checkmark.circle")
//                                .padding()
//                                .background(.black.opacity(0.7))
//                                .clipShape(Circle())
//                        }
//                        .accessibilityLabel("Correct")
//                        .accessibilityHint("Mark your answer is being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }

    func loadData() {
//        if let data = UserDefaults.standard.data(forKey: "Cards") {
//            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decoded
//            }
//        }
        cards = load("cards")
    }

    func removeCard(at index: Int) -> Card? {
        guard index >= 0 else { return nil }
        let removedCard = cards.remove(at: index)
        return removedCard
    }
    
    func onCorrectAnswer(cardAt index: Int) -> Void {
        _ = removeCard(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func onWrongAnswer(cardAt index: Int) -> Void {
        let card = removeCard(at: index)
        if let unwrappedCard = card {
            cards.insert(unwrappedCard.duplicate(), at: 0)
            isActive = true
        }
    }

    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
