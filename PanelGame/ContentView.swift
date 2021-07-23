//
//  ContentView.swift
//  PanelGame
//
//  Created by user1 on 2021/07/21.
//

import SwiftUI

struct ContentView: View {
    //  パネルの縦横の長さ
    let gridLength = (UIScreen.main.bounds.size.width - 60) / 3
    //  パネルの数、レイアウト設定
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 3)
    // パネルの状態を配列で管理
    @State var panels = Array(repeating: "", count: 9)
    // 二人のプレイヤーを切り替えるためのBool値
    @State var playerSwitcher = true
    
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
