//
//  ContentView.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    @Namespace private var discardNamespace
    @Namespace private var dealingNamespace
    
    @State private var dealt = Set<Int>()
    @State private var dealCounter = 0
    @State private var discarded = Set<Int>()
    @State private var showNoSetsAlert = false
    
    var body: some View {
        VStack() {
            AspectVGrid(items: game.deck.filter(isDealt), aspectRatio: CardConstants.aspectRatio) { card in
                if !isUndealt(card) {
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .matchedGeometryEffect(id: card.id, in: discardNamespace)
                        .padding(4)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                        .zIndex(zIndex(of: card))
                        .foregroundColor(CardConstants.cardColor)
                        .onTapGesture {
                            getDiscards()
                            withAnimation {
                                game.choose(card)
                            }
                        }.onAppear() {
                            withAnimation(flipAnimation(for: card)){
                                flip(card)
                            }
                        }
                }
            }
            HStack {
                newGame
                Spacer()
                cheat
                Spacer()
                discardBody
                Spacer()
                deckBody
            }.padding(.horizontal)
        }.alert(isPresented: $showNoSetsAlert, content: {
          Alert(title: Text("No sets on screen"), dismissButton: .default(Text("OK")) {
              showNoSetsAlert = false
          })
        })
    }
    
    private func deal(_ card: SetGame.Card) {
        dealt.insert(card.id)
        dealCounter += 1
        game.deal(cardId: card.id)
    }
    
    private func flip(_ card: SetGame.Card) {
        game.flip(cardId: card.id)
    }
    
    private func isUndealt(_ card: SetGame.Card) -> Bool {
        return !dealt.contains(card.id) && !discarded.contains(card.id)
    }
    
    private func isDealt(_ card: SetGame.Card) -> Bool {
        return dealt.contains(card.id) && !discarded.contains(card.id)
    }
    
    private func isDiscard(_ card: SetGame.Card) -> Bool {
        return discarded.contains(card.id)
    }
    
    private func dealAnimation(for card: SetGame.Card, _ index: Int) -> Animation {
        let delay = Double(index) * CardConstants.cardDealDelay
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func flipAnimation(for card: SetGame.Card) -> Animation {
        var min = CardConstants.initDealFlipDelay
        if dealCounter > CardConstants.initialDealCount {
            min = CardConstants.successiveDealDelay
        }
        let dealt = game.deck.filter(isDealt)
        let index = dealt.firstIndex(of: card)
        let del = min + CardConstants.totalDealDuration * Double(index!) / Double(dealt.count)
        return Animation.easeInOut(duration: CardConstants.flipDuration).delay(del)
    }
    
    private func zIndex(of card: SetGame.Card) -> Double {
        -Double(game.deck.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    private func zIndexDiscard(of card: SetGame.Card) -> Double {
        -Double(game.deck.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.cardColor)
        .onTapGesture {
            // "deal" cards
            var dealCards = 0
            if dealt.isEmpty {
                dealCards = CardConstants.initialDealCount
            }
            else {
                dealCards = CardConstants.successiveDealCount
            }
            for i in 1...dealCards {
                if game.dealButtonEnabled() {
                    withAnimation(dealAnimation(for: game.deck[dealCounter], i)) {
                        deal(game.deck[dealCounter])
                    }
                }
            }
            getDiscards()
        }
    }
    
    private func getDiscards() {
        withAnimation {
            let discards = game.deck.filter{$0.isDiscarded}
            for card in discards {
                if !discarded.contains(card.id) {
                    discarded.insert(card.id)
                }
            }
        }
        game.discard()
    }
    
    var discardBody: some View {
        ZStack {
            ForEach(game.deck.filter(isDiscard)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .transition(AnyTransition.slide)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    }
    
    var newGame: some View {
        Button {
            withAnimation {
                dealt = []
                discarded = []
                dealCounter = 0
                game.newGame()
            }
        } label: {
            VStack {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.largeTitle)
                Text("New Game")
                    .font(.body)
            }
        }
    }
    
    var cheat: some View {
        Button {
            getDiscards()
            withAnimation {
                showNoSetsAlert = game.cheat()
            }
        } label: {
            VStack {
                Image(systemName: "graduationcap.circle")
                    .font(.largeTitle)
                Text("Cheat")
                    .font(.body)
            }
        }
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let cardDealDelay: Double = 0.15
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
        static let initDealFlipDelay = 2.0
        static let successiveDealDelay = -0.5
        static let initialDealCount = 12
        static let successiveDealCount = 3
        static let flipDuration = 0.7
        static let cardColor = Color.teal
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}


