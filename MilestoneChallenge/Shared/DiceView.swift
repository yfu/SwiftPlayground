//
//  DiceView.swift
//  MilestoneChallenge
//
//  Created by Yu Fu on 4/2/22.
//

import SwiftUI

struct DiceView: View {
    @Binding var dice: Dice
    @State var isFlickering: Bool
    
    var body: some View {
        VStack {
            Text("\(dice.number)")
                .font(.largeTitle)
                .foregroundColor(isFlickering ? .gray : .white)
                .frame(width: 50, height: 50)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            Text("Total: \(dice.total)")
        }
    }
}

//struct DiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiceView(dice: Binding.constant(Dice()))
//    }
//}
