//
//  HomeViewModel.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/16.
//

import Foundation

class HomeViewModel: ObservableObject {
    // パネル数
    private let NUMBER_OF_PANELS = 16
    // パネルの状態を配列で管理
    @Published var panels: [PlayerModel]!
    // 現在の差し手を管理
    @Published var currentPlayer: PlayerModel!
    // 先手プレイヤー管理
    @Published var firstPlayer: PlayerModel!
    // ゲーム中かを管理
    @Published var isStartingGame: Bool!
    // アラートを表示するか管理
    @Published var showAlert: Bool!
    
    // 初期化処理
    init() {
        gameSet()
    }
    
    // 勝敗を判定する
    func judgeGame(player: PlayerModel){
        //　勝利条件を満たしていた場合の処理
        if hasWon(player) {
            showAlert = true
        }
        // 引き分け時の処理
        else if panels.contains(PlayerModel.none) == false {
            currentPlayer = PlayerModel.none
            showAlert = true
            // 引き分けでも勝利でもない場合の処理
        } else{
            // プレイヤーを切り替える
            currentPlayer.togglePlayer()
        }
    }
    
    // 勝利条件が確定しているのかチェックする
    func hasWon(_ player: PlayerModel) -> Bool {
        // 勝利判定管理用に利用する
        var canWin = false
        
        // 横方向で図柄が揃ったかチェックする
        if canWin == false {
            for i in stride(from: 0, to: NUMBER_OF_PANELS, by: 4){
                for j in stride(from: i, to: i + 4, by: 1){
                    guard player == panels[j] else{
                        canWin = false
                        break
                    }
                    canWin = true
                }
                if canWin { break }
            }
        }
        // 縦方向で図柄が揃ったかチェックする
        if canWin == false {
            for i in stride(from: 0, to: 4, by: 1){
                for j in stride(from: i, to: NUMBER_OF_PANELS, by: 4){
                    guard player == panels[j] else{
                        canWin = false
                        break
                    }
                    canWin = true
                }
                if canWin { break }
            }
        }
        // 左上から右下に図柄が揃ったかチェックする
        if canWin == false {
            for i in stride(from: 0, to: NUMBER_OF_PANELS, by: 5){
                guard player == panels[i] else{
                    canWin = false
                    break
                }
                canWin = true
            }
        }
        // 右上から左下に図柄が揃ったかチェックする
        if canWin == false {
            for i in stride(from: 3, through: 12, by: 3){
                guard player == panels[i] else{
                    canWin = false
                    break
                }
                canWin = true
            }
        }
        // 勝敗を返却する
        return canWin
    }
    
    // gameを初期状態に戻す
    func gameSet(){
        panels = Array(repeating: PlayerModel.none, count: NUMBER_OF_PANELS)
        firstPlayer = PlayerModel.none
        currentPlayer = PlayerModel.grandPa
        isStartingGame = false
        showAlert = false
    }
}
