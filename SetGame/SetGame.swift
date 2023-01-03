//
//  SetGame.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import Foundation

struct SetGame {
    
    private(set) var cards: Array<Card>

    mutating func choose(_ card: Card) {
        
        let setCards = cards.filter{$0.isSet == true && $0.isDiscarded == false}
        if setCards.count > 0 {
            replaceCards(set: setCards)
        }
        let badSetCards = cards.filter{$0.isSet == false}
        for card in badSetCards {
            if let index = cards.firstIndex(where:{$0.id == card.id}){
                cards[index].isSet = nil
            }
        }
        
        if let index = cards.firstIndex(where:{$0.id == card.id}) {
            cards[index].isSelected.toggle()
        }
        let selectedCards = cards.filter{$0.isSelected}
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
            if let index = cards.firstIndex(where:{$0.id == card.id}) {
                if num && col && shp && shd {
                    cards[index].isDiscarded = true
                    cards[index].isSet = true
                    foundSet = true
                } else {
                    cards[index].isSet = false
                }
                cards[index].isSelected = false
            }
        }
        return foundSet
    }
    
    mutating func deal(cardId: Int) {
        if let i = cards.firstIndex(where:{$0.id == cardId}) {
            cards[i].isDealt = true
        }
    }
    
    mutating func flip(cardId: Int) {
        if let i = cards.firstIndex(where:{$0.id == cardId}) {
            cards[i].isFaceUp = true
        }
    }
    
    mutating func discard() {
        let discards = cards.filter{$0.isDiscarded}
        for card in discards {
            if let i = cards.firstIndex(where:{$0.id == card.id}) {
                cards[i].isSet = nil
                cards[i].isSelected = false
            }
        }
    }
    
    mutating func discardSet() {
        let setCards = cards.filter{$0.isSet == true}
        if setCards.count > 0 {
            replaceCards(set: setCards)
        }
    }

    mutating func replaceCards(set: [Card]) {
        for card in set {
            if let index = cards.firstIndex(where: {$0.id == card.id}) {
                cards[index].isDiscarded = true
                cards[index].isSet = nil
            }
        }
    }
    
    mutating func highlightSet() -> Bool {
        let visibleCards = cards.filter{$0.isDealt == true && $0.isDiscarded == false}

        for card1 in visibleCards {
            for card2 in visibleCards {
                for card3 in visibleCards {
                    if card1.id != card2.id && card2.id != card3.id && card1.id != card3.id {
                        if checkSet([card1, card2, card3]) {
                            return true
                        } else {
                            if let index1 = cards.firstIndex(where:{$0.id == card1.id}) {
                                cards[index1].isSet = nil
                            }
                            if let index2 = cards.firstIndex(where:{$0.id == card2.id}) {
                                cards[index2].isSet = nil
                            }
                            if let index3 = cards.firstIndex(where:{$0.id == card3.id}) {
                                cards[index3].isSet = nil
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func canDealCards() -> Bool {
        let remainingDeck = cards.filter{$0.isDealt == false}
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
    }
    struct Card: Identifiable, Equatable {
        let number: SetNumber
        let shape: SetShape
        let shading: SetShading
        let color: SetColor
        var isSelected = false
        var isSet: Bool?
        var isDealt = false
        var isDiscarded = false
        var isFaceUp = false
        let id: Int
    }
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


