//
//  SetGame.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import Foundation

struct SetGame { 
    
    private(set) var visibleCards: [Card]
    private var remainingDeck: [Card]
    private var cards: Array<Card>
    private var score: Int = 0

    mutating func choose(_ card: Card) {
        let setCards = visibleCards.filter{$0.isSet == true}
        if setCards.count > 0 {
            replaceCards(set: setCards)
        }
        let badSetCards = visibleCards.filter{$0.isSet == false}
        for card in badSetCards {
            if let index = visibleCards.firstIndex(where:{$0.id == card.id}){
                visibleCards[index].isSet = nil
            }
        }
        
        if let index = visibleCards.firstIndex(where:{$0.id == card.id}) {
            visibleCards[index].isSelected.toggle()
        }
        let selectedCards = visibleCards.filter{$0.isSelected}
        if selectedCards.count == 3 {
            let _ = checkSet(selectedCards)
        }
    }
    
    mutating func checkSet(_ selections: [Card]) -> Bool {
        if selections.count != 3 {
            return false
        }
        let c1 = selections[0]
        let c2 = selections[1]
        let c3 = selections[2]
        
        let num = (c1.number == c2.number && c3.number == c1.number) || (c1.number != c2.number && c2.number != c3.number && c3.number != c1.number)
        let col = (c1.color == c2.color && c3.color == c1.color) || (c1.color != c2.color && c2.color != c3.color && c3.color != c1.color)
        let shp = (c1.shape == c2.shape && c3.shape == c1.shape) || (c1.shape != c2.shape && c2.shape != c3.shape && c3.shape != c1.shape)
        let shd = (c1.shading == c2.shading && c3.shading == c1.shading) || (c1.shading != c2.shading && c2.shading != c3.shading && c3.shading != c1.shading)
        
        var foundSet = false
        for card in selections {
            if let index = visibleCards.firstIndex(where:{$0.id == card.id}) {
                if num && col && shp && shd {
                    visibleCards[index].isSet = true
                    foundSet = true
                } else {
                    visibleCards[index].isSet = false
                }
                visibleCards[index].isSelected = false
            }
        }
        return foundSet
    }
    
    mutating func dealThreeCards() {
        let setCards = visibleCards.filter{$0.isSet == true}
        if setCards.count > 0 {
            replaceCards(set: setCards)
        } else {
            for _ in 1...3 {
                if remainingDeck.count > 0 {
                    visibleCards.append(remainingDeck.removeFirst())
                }
            }
        }
    }

    mutating func replaceCards(set: [Card]) {
        for card in set {
            if let index = visibleCards.firstIndex(where: {$0.id == card.id}) {
                visibleCards.remove(at:index)
                if remainingDeck.count > 0 {
                    visibleCards.insert(remainingDeck.removeFirst(), at:index)
                }
            }
        }
    }
    
    mutating func highlightSet() -> Bool {
        for card1 in visibleCards {
            for card2 in visibleCards {
                for card3 in visibleCards {
                    if card1.id != card2.id && card2.id != card3.id && card1.id != card3.id {
                        if checkSet([card1, card2, card3]) {
                            return true
                        } else {
                            if let index1 = visibleCards.firstIndex(where:{$0.id == card1.id}) {
                                visibleCards[index1].isSet = nil
                            }
                            if let index2 = visibleCards.firstIndex(where:{$0.id == card2.id}) {
                                visibleCards[index2].isSet = nil
                            }
                            if let index3 = visibleCards.firstIndex(where:{$0.id == card3.id}) {
                                visibleCards[index3].isSet = nil
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func canDealCards() -> Bool {
        return !remainingDeck.isEmpty
    }
    
    init () {
        cards = []
        var id = 0
        for shape in SetShape.allCases {
            for shading in SetShading.allCases {
                for col in SetColor.allCases {
                    for num in SetNumber.allCases {
                        cards.append(Card(number: num, shape: shape, shading: shading, color: col, id: id))
                        id += 1
                    }
                }
            }
        }
        cards.shuffle()
        visibleCards = Array(cards[0..<12])
        remainingDeck = Array(cards[12...])
    }
    
    struct Card: Identifiable {
        let number: SetNumber
        let shape: SetShape
        let shading: SetShading
        let color: SetColor
        var isSelected = false
        var isSet: Bool?
        let id: Int
    }
        
    enum SetShape: CaseIterable{
        case diamond, oval, rectangle 
    }
    
    enum SetShading: CaseIterable {
        case solid, open, striped
    }
    
    enum SetColor: CaseIterable {
        case red, green, purple
    }
    
    enum SetNumber: CaseIterable {
        case one, two, three
    }
}
