//
//  Diamond.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let start = CGPoint(x:center.x, y:0)
        let left = CGPoint(x:0, y:center.y)
        let right = CGPoint(x:rect.width, y:center.y)
        let bot = CGPoint(x:center.x, y:rect.height)
        
        var p = Path()
        p.move(to:start)
        p.addLine(to:left)
        p.addLine(to:bot)
        p.addLine(to:right)
        p.addLine(to: start)
        
        return p
    }
}
