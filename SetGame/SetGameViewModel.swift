//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import Foundation

class SetGameViewModel : ObservableObject {

    @Published private var gameModel = SetGame() //theme: createRandomTheme())

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
    
    func dealThreeCards() {
        gameModel.dealThreeCards()
    }
    
    func dealButtonDisabled() -> Bool {
        return gameModel.remainingDeck.isEmpty
    }
    
    var cards: Array<SetGame.Card> {
        return gameModel.visibleCards
    }
}
