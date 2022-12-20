//
//  ContentView.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        VStack() {
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            HStack {
                newGame
                Spacer()
                dealThree
            }.padding(.horizontal)
        }
    }
    
    var newGame: some View {
        Button {
            game.newGame()
        } label: {
            VStack {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.largeTitle)
                Text("New Game")
                    .font(.body)
            }
        }
    }
    var dealThree: some View {
        Button {
            game.dealThreeCards()
        } label: {
            VStack {
                Image(systemName: "square.3.layers.3d.down.right")
                    .font(.largeTitle)
                Text("Deal Three")
                    .font(.body)
            }
        }.disabled(game.dealButtonDisabled())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}


