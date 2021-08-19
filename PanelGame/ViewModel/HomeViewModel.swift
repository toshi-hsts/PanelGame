//
//  HomeViewModel.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/16.
//

import Foundation

class HomeViewModel: ObservableObject {
    // パネルの状態を配列で管理
    @Published var panels: [PanelStateModel] = Array(repeating: PanelStateModel.none, count: 16)
    // 現在の差し手を管理
    @Published var currentPlayer = CurrentPlayerModel.none
    // 先手プレイヤー管理
    @Published var firstPlayer = FirstPlayerModel.none
    // アラートを表示するか管理
    @Published var showAlert = false
    // ゲーム中かを管理
    @Published var isStartingGame = false
    
    // 勝敗を判定する
    func judgeGame(player: String){
        //　勝利条件を満たしていた場合の処理
        if hasWon(player: player) {
            showAlert = true
        }
        // 引き分け時の処理
        else if panels.contains(PanelStateModel.none) == false {
            currentPlayer = .none
            showAlert = true
            // 引き分けでも勝利でもない場合の処理
        } else{
            // プレイヤーを切り替える
            currentPlayer.togglePlayer()
        }
    }
    
    // 勝利条件が確定しているのかチェックする
    func hasWon(player: String) -> Bool {
        // 勝利判定管理用に利用する
        var canWin = false
        
        // 横方向で図柄が揃ったかチェックする
        if canWin == false {
            for i in stride(from: 0, through: 12, by: 4){
                for j in stride(from: i, through: i + 3, by: 1){
                    guard player == panels[j].toString() else{
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
            for i in stride(from: 0, through: 3, by: 1){
                for j in stride(from: i, through: i + 12, by: 4){
                    guard player == panels[j].toString() else{
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
            for i in stride(from: 0, through: 15, by: 5){
                guard player == panels[i].toString() else{
                    canWin = false
                    break
                }
                canWin = true
            }
        }
        // 右上から左下に図柄が揃ったかチェックする
        if canWin == false {
            for i in stride(from: 3, through: 12, by: 3){
                guard player == panels[i].toString() else{
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
        panels = Array(repeating: PanelStateModel.none, count: 16)
        firstPlayer = .none
        currentPlayer = .none
        isStartingGame = false
    }
}
