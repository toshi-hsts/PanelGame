//
//  PlayerImageView.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/22.
//

import Foundation
import SwiftUI

struct PlayerImageView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    let gridLength: CGFloat
    let player: PlayerModel
    
    var body: some View {
        VStack{
            Text(homeViewModel.isStartingGame && homeViewModel.currentPlayer == player ? "▼" : " ")
                .font(.title)
            Button(action: {
                guard homeViewModel.isStartingGame == false else {
                    return
                }
                homeViewModel.currentPlayer = player
            }) {
                Image(player.toString())
                    .resizable()
                    .scaledToFit()
                    .frame(width: gridLength * 1.5, height: gridLength * 1.5)
                    .padding(.horizontal, 10)
            }
        }
    }
}
