//
//  ContentView.swift
//  PanelGame
//
//  Created by user1 on 2021/07/21.
//

import SwiftUI

struct HomeView: View {
    //  パネルの縦横の長さ
    private let gridLength = (UIScreen.main.bounds.size.width - 75) / 4
    //  パネルの数、レイアウト設定
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 4)
    // HomeViewModelをインスタンス化
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    VStack{
                        // おじいちゃんのターンが分かるよう「▼」を付与
                        Text(homeViewModel.fixedFirstPlayer && homeViewModel.isGrandpa ? "▼" : "　")
                            .font(.title)
                        // おじいちゃんボタン
                        Button(action: {
                            guard homeViewModel.fixedFirstPlayer == false else {
                                return
                            }
                            homeViewModel.firstPlayerMessage = "先手：おじいちゃん"
                            homeViewModel.isGrandpa = true
                        }) {
                            Image("ojiichan")
                                .resizable()
                                .scaledToFit()
                                .frame(width: gridLength * 1.5, height: gridLength * 1.5)
                                .padding(.horizontal, 10)
                        }
                    }
                    // VSテキストを表示
                    Text("VS")
                        .font(.largeTitle)
                        .padding(.horizontal,10)
                    
                    VStack{
                        // おばあちゃんのターンが分かるよう「▼」を付与
                        Text(homeViewModel.fixedFirstPlayer && (homeViewModel.isGrandpa == false) ? "▼" : " ")
                            .font(.title)
                        // おばあちゃんボタン
                        Button(action: {
                            guard homeViewModel.fixedFirstPlayer == false else {
                                return
                            }
                            homeViewModel.firstPlayerMessage = "先手：おばあちゃん"
                            homeViewModel.isGrandpa = false
                        }) {
                            Image("obaachan")
                                .resizable()
                                .scaledToFit()
                                .frame(width: gridLength * 1.5, height: gridLength * 1.5)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                // 先手をテキストで表示する
                Text(homeViewModel.firstPlayerMessage)
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                    ForEach((0...15), id: \.self) { panelNumber in
                        ZStack {
                            // 角丸の四角形を描画する
                            RoundedRectangle(cornerRadius: 10)
                                // パネルの色
                                .changePanelColor(homeViewModel.panels[panelNumber])
                                // gridの高さ
                                .frame(height: gridLength)
                            // パネルに割り当てられたプレイヤーがいる場合、パネルの上に画像を表示する
                            if homeViewModel.panels[panelNumber].isEmpty == false {
                                Image(homeViewModel.panels[panelNumber])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: gridLength * 0.7, height: gridLength * 0.7, alignment: .center)
                            }
                        }
                        // tapしたときの挙動
                        .onTapGesture {
                            // 選択済みのパネルの場合は、何もしない
                            guard homeViewModel.panels[panelNumber].isEmpty else {
                                return
                            }
                            // 最初にパネルがタップされたときに先手を確定させる
                            if homeViewModel.fixedFirstPlayer == false {
                                homeViewModel.firstPlayerMessage = homeViewModel.isGrandpa ? "先手：おじいちゃん" : "先手：おばあちゃん"
                                homeViewModel.fixedFirstPlayer = true
                            }
                            // アニメーションを利用する
                            withAnimation(){
                                // パネルのプレイヤーを格納
                                homeViewModel.panels[panelNumber] = homeViewModel.isGrandpa ? "ojiichan":"obaachan"
                            }
                            // 勝敗を判定する
                            homeViewModel.judgeGame(player: homeViewModel.panels[panelNumber])
                        }
                        // パネルをめくるアニメーション設定
                        .rotation3DEffect(
                            Angle.degrees(homeViewModel.panels[panelNumber].isEmpty ? 0 : 180),
                            axis: (x:0, y:1, z:0),
                            anchor: .center,
                            perspective: 1)
                    }
                }
                // 15ポイントの余白を水平方向に付与
                .padding(.horizontal, 15)
                // どちらのターンかを知らせるメッセージ
                Text(homeViewModel.turnMessage)
                    .padding()
                    .font(.title)
            }
            // ナビゲーションバータイトル
            .navigationTitle("四目並べ")
        }
        // ダークモード に強制する
        .preferredColorScheme(.dark)
        // アラートを表示する
        .alert(isPresented: $homeViewModel.showAlert, content: {
            Alert(title: Text("勝者"),
                  message: Text(homeViewModel.alertMessage),
                  dismissButton: .destructive(Text("もう一度！"),
                                              action: {
                                                // アニメーションを利用する
                                                withAnimation(){
                                                    homeViewModel.gameSet()
                                                }
                                              }
                  )
            )
        })
    }
}

//　RoundedRectangleのモディファイア拡張
extension RoundedRectangle {
    // 背景色をpanelよって変更する
    func changePanelColor(_ panelContent: String) -> some View {
        var fillColor = self.fill(Color.white)
        if panelContent == "ojiichan"{ fillColor =  self.fill(Color.blue) }
        if panelContent == "obaachan"{ fillColor = self.fill(Color.orange) }
        return fillColor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
