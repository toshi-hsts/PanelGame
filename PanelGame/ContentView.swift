//
//  ContentView.swift
//  PanelGame
//
//  Created by user1 on 2021/07/21.
//

import SwiftUI

struct ContentView: View {
    //  パネルの縦横の長さ
    private let gridLength = (UIScreen.main.bounds.size.width - 60) / 3
    //  パネルの数、レイアウト設定
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 3)
    // パネルの状態を配列で管理
    @State private var panels = Array(repeating: "", count: 9)
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
                    ForEach((0...8), id: \.self) { panelNumber in
                        ZStack {
                            // パネルが空白のときの処理
                            if panels[panelNumber].isEmpty {
                                // 角丸の四角形を描画する
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: gridLength)
                                    // tapしたときの挙動
                                    .onTapGesture {
                                        // パネルのプレイヤーを格納
                                        panels[panelNumber] = playerSwitcher ? "🐶":"😸"
                                        // プレイヤーを切り替える
                                        playerSwitcher.toggle()
                                        //　勝利条件を満たしていた場合の処理
                                        if checkPanels(player: panels[panelNumber]) {
                                            alertMessage = "プレイヤー\(panels[panelNumber])　勝利！！！"
                                            showAlert = true
                                        }
                                    }
                                // パネルが埋まっているときの処理
                            } else {
                                // パネルをオレンジにする
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.orange)
                                    .frame(height: gridLength)
                                // パネルの上にプレイヤーを表示する
                                Text(panels[panelNumber])
                                    .font(.system(size: gridLength / 2))
                            }
                        }
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
    
    // gameを初期状態に戻す
    func gameSet(){
        panels = Array(repeating: "", count: 9)
        playerSwitcher = true
    }
    
    // 勝利条件が確定しているのかチェックする
    func checkPanels(player: String) -> Bool {
        // 勝利判定管理用に利用する
        var canWin = false
        
        // 横方向で図柄が揃ったかチェックする
        for i in stride(from: 0, through: 6, by: 3){
            for j in stride(from: i, through: i + 2, by: 1){
                guard player == panels[j] else{
                    canWin = false
                    break
                }
                canWin = true
            }
            if canWin{ return true }
        }
        
        // 縦方向で図柄が揃ったかチェックする
        for i in stride(from: 0, through: 2, by: 1){
            for j in stride(from: i, through: i + 6, by: 3){
                guard player == panels[j] else{
                    canWin = false
                    break
                }
                canWin = true
            }
            if canWin{ return true }
        }
        
        // 左上から右下に図柄が揃ったかチェックする
        for i in stride(from: 0, through: 8, by: 4){
            guard player == panels[i] else{
                canWin = false
                break
            }
            canWin = true
        }
        
        guard !canWin else{ return true }
        
        // 右上から左下に図柄が揃ったかチェックする
        for i in stride(from: 2, through: 6, by: 2){
            guard player == panels[i] else{
                canWin = false
                break
            }
            canWin = true
        }
        
        guard !canWin else{ return true }

        // 勝利条件を満たしていない場合はfalseを返す
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
