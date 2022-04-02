//
//  CustomModifiers.swift
//  Flashzilla
//
//  Created by Yu Fu on 3/20/22.
//

import SwiftUI

extension Shape {
    func fillBasedOnComparison(for value: Double, threshold: Double, lt: Color, eq: Color, gt: Color) ->  some View {
        if value < threshold {
            return self.fill(lt)
        } else if value == threshold {
            return self.fill(eq)
        } else {
            return self.fill(gt)
        }
    }
}


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}
