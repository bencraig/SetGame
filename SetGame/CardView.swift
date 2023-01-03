//
//  CardView.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: getLineWidth())
                    .padding(DrawingConstants.borderPadding).opacity(DrawingConstants.borderOpacity).foregroundColor(borderColor())

                shapeDesign().padding(.all)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .rotationEffect(Angle.degrees(card.isSet == true ? 360 : 0))
            .rotationEffect(Angle.degrees(card.isSet == false ? DrawingConstants.incorrectSkewAngle : 0))
        }
    }
    
    @ViewBuilder
    private func shapeDesign() -> some View {
        let c = shapeColor()
        let f = fillColor()
        let repeatedCount = (1...getRepeatedCount())

        VStack{
            ForEach(repeatedCount, id: \.self) { _ in
                switch card.shape {
                case .oval:
                    Circle().strokeBorder(c,lineWidth: DrawingConstants.lineWidth).background(Circle().fill(f))
                case .diamond:
                    Diamond().stroke(c, lineWidth:DrawingConstants.lineWidth).background(Diamond().fill(f))
                case .rectangle:
                    RoundedRectangle(cornerRadius:DrawingConstants.cornerRadius).strokeBorder(c, lineWidth:DrawingConstants.lineWidth).background(RoundedRectangle(cornerRadius:DrawingConstants.cornerRadius).fill(f))
                }
            }
        }
    }
    
    private func fillColor() -> Color {
        switch card.shading {
        case .open:
            return Color.white
        case .solid:
            return shapeColor()
        case .striped:
            return shapeColor().opacity(0.5)
        }
    }
    
    private func getLineWidth() -> CGFloat {
        if card.isSet == true || card.isSelected {
            return DrawingConstants.setLineWidth
        } else {
            return DrawingConstants.lineWidth
        }
    }
    
    private func getRepeatedCount() -> Int {
        let count : Int
        switch card.number {
        case .three:
            count = 3
        case .two:
            count = 2
        case .one:
            count = 1
        }
        return count
    }

    private func shapeColor() -> Color {
        switch card.color {
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        case .green:
            return Color.green
        }
    }
    
    private func borderColor() -> Color { 
        if card.isSet == true {
            return Color.blue.opacity(1)
        } else if card.isSet == false {
            return Color.black
        }
        if card.isSelected {
            return Color.orange
        } else {
            return Color.cyan
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale )
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3.0
        static let setLineWidth: CGFloat = 5.0
        static let fontScale: CGFloat = 0.7
        static let borderPadding = 5.0
        static let borderOpacity = 0.8
        static let incorrectSkewAngle = 4.0
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: SetGame.Card(number: SetNumber.three, shape: SetShape.rectangle, shading: SetShading.open, color: SetColor.red, id: 1))
    }
}

