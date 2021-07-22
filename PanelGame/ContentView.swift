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
    
    var body: some View {
        NavigationView{
            VStack{
                LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                    ForEach((0...8), id: \.self) { num in
                        ZStack {
                            // 角丸の四角形を描画する
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: gridLength)
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
