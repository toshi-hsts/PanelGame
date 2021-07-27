//
//  ContentView.swift
//  PanelGame
//
//  Created by user1 on 2021/07/21.
//

import SwiftUI

struct ContentView: View {
    //  パネルの縦横の長さ
    private let gridLength = (UIScreen.main.bounds.size.width - 75) / 4
    //  パネルの数、レイアウト設定
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 4)
    // パネルの状態を配列で管理
    @State private var panels = Array(repeating: "", count: 16)
    // 二人のプレイヤーを切り替えるためのBool値
    @State private var playerSwitcher = true
    // アラートを表示するか管理
    @State private var showAlert = false
    // アラートメッセージ
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView{
            VStack{
                LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                    ForEach((0...15), id: \.self) { panelNumber in
                        ZStack {
                            // 角丸の四角形を描画する
                            RoundedRectangle(cornerRadius: 10)
                                // パネルの色
                                .changePanelColor(panels[panelNumber])
                                // gridの高さ
                                .frame(height: gridLength)
                                // tapしたときの挙動
                                .onTapGesture {
                                    // 選択済みのパネルの場合は、何もしない
                                    guard panels[panelNumber].isEmpty else {
                                        return
                                    }
                                    // アニメーションを利用する
                                    withAnimation(){
                                        // パネルのプレイヤーを格納
                                        panels[panelNumber] = playerSwitcher ? "🐶":"😸"
                                    }
                                    // プレイヤーを切り替える
                                    playerSwitcher.toggle()
                                    // 勝敗を判定する
                                    judgeGame(player: panels[panelNumber])
                                }
                            // プレイヤーをパネルの上に表示する
                            Text(panels[panelNumber])
                                .font(.system(size: gridLength / 2))
                        }
                        // パネルをめくるアニメーション設定
                        .rotation3DEffect(
                            Angle.degrees(panels[panelNumber].isEmpty ? 0 : 180),
                            axis: (x:0, y:1, z:0),
                            anchor: .center,
                            perspective: 1)
                    }
                }
                // 15ポイントの余白を水平方向に付与
                .padding(.horizontal, 15)
            }
            // ナビゲーションバータイトル
            .navigationTitle("パネルゲーム")
        }
        // ダークモード に強制する
        .preferredColorScheme(.dark)
        // アラートを表示する
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("勝者"),
                  message: Text(alertMessage),
                  dismissButton: .destructive(Text("もう一度！"),
                                              action: {
                                                gameSet()
                                              }
                  )
            )
        })
    }
    
    // 勝敗を判定する
    func judgeGame(player: String){
        //　勝利条件を満たしていた場合の処理
        if hasWon(player: player) {
            alertMessage = "プレイヤー\(player)　勝利！！！"
            showAlert = true
        }
        // 引き分け時の処理
        else if panels.contains("") == false {
            alertMessage = "引き分け！！！"
            showAlert = true
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
            for i in stride(from: 0, through: 3, by: 1){
                for j in stride(from: i, through: i + 12, by: 4){
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
            for i in stride(from: 0, through: 15, by: 5){
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
        // アニメーションを利用する
        withAnimation(){
            panels = Array(repeating: "", count: 16)
        }
        playerSwitcher = true
    }
}

//　RoundedRectangleのモディファイア拡張
extension RoundedRectangle {
    // 背景色をpanelよって変更する
    func changePanelColor(_ panelContent: String) -> some View {
        var fillColor = self.fill(Color.white)
        if panelContent == "🐶"{ fillColor =  self.fill(Color.blue) }
        if panelContent == "😸"{ fillColor = self.fill(Color.orange) }
        return fillColor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
