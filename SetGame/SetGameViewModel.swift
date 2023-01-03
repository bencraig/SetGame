//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import Foundation

class SetGameViewModel : ObservableObject {

    @Published private var gameModel = SetGame()
    
    init() {
        newGame()
    }
    
    //MARK: - Intents
    func newGame() {
       gameModel = SetGame()
    }
    
    func choose(_ card: SetGame.Card) {
        gameModel.choose(card)
    }
    
    func deal(cardId: Int) {
        gameModel.deal(cardId: cardId)
    }
    
    func flip(cardId: Int) {
        gameModel.flip(cardId: cardId)
    }
    
    func cheat() -> Bool {
        return !gameModel.highlightSet()
    }
    
    func dealButtonEnabled() -> Bool {
        return gameModel.canDealCards()
    }
    
    func discard() {
        gameModel.discard()
    }
    
    var deck: Array<SetGame.Card> {
        return gameModel.cards
    }
}
