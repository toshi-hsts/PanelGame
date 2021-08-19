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
                        Text(homeViewModel.fixedFirstPlayer && homeViewModel.currentUser == .grandPa ? "▼" : "　")
                            .font(.title)
                        // おじいちゃんボタン
                        Button(action: {
                            guard homeViewModel.fixedFirstPlayer == false else {
                                return
                            }
                            homeViewModel.firstPlayerMessage = FirstPlayerMessageModel.grandPa.message
                            homeViewModel.currentUser = .grandPa
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
                        Text(homeViewModel.fixedFirstPlayer && homeViewModel.currentUser == .grandMa ? "▼" : " ")
                            .font(.title)
                        // おばあちゃんボタン
                        Button(action: {
                            guard homeViewModel.fixedFirstPlayer == false else {
                                return
                            }
                            homeViewModel.firstPlayerMessage = FirstPlayerMessageModel.grandMa.message
                            homeViewModel.currentUser = .grandMa
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
                                .changePanelColor(homeViewModel.panels[panelNumber].toString())
                                // gridの高さ
                                .frame(height: gridLength)
                            // パネルに割り当てられたプレイヤーがいる場合、パネルの上に画像を表示する
                            if homeViewModel.panels[panelNumber] != .none {
                                Image(homeViewModel.panels[panelNumber].toString())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: gridLength * 0.7, height: gridLength * 0.7, alignment: .center)
                            }
                        }
                        // tapしたときの挙動
                        .onTapGesture {
                            // 選択済みのパネルの場合は、何もしない
                            guard homeViewModel.panels[panelNumber] == .none else {
                                return
                            }
                            // 最初にパネルがタップされたときに先手を確定させる
                            if homeViewModel.fixedFirstPlayer == false {
                                homeViewModel.currentUser = .grandPa
                                homeViewModel.firstPlayerMessage = homeViewModel.currentUser == .grandPa ? FirstPlayerMessageModel.grandPa.message : FirstPlayerMessageModel.grandMa.message
                                homeViewModel.fixedFirstPlayer = true
                            }
                            // アニメーションを利用する
                            withAnimation(){
                                // パネルのプレイヤーを格納
                                homeViewModel.panels[panelNumber] = homeViewModel.currentUser == .grandPa ? PanelStateModel.grandPa : PanelStateModel.grandMa
                            }
                            // 勝敗を判定する
                            homeViewModel.judgeGame(player: homeViewModel.panels[panelNumber].toString())
                        }
                        // パネルをめくるアニメーション設定
                        .rotation3DEffect(
                            Angle.degrees(homeViewModel.panels[panelNumber] == .none ? 0 : 180),
                            axis: (x:0, y:1, z:0),
                            anchor: .center,
                            perspective: 1)
                    }
                }
                // 15ポイントの余白を水平方向に付与
                .padding(.horizontal, 15)
                // どちらのターンかを知らせるメッセージ
                Text(homeViewModel.currentUser.whoseTurnMessage)
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
                  message: Text(homeViewModel.currentUser.alertMessage),
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
