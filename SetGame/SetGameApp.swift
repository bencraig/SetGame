//
//  SetGameApp.swift
//  SetGame
//
//  Created by Benjamin Craig on 12/12/22.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
