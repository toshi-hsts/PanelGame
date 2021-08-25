//
//  CurrentTurnUserModel.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/19.
//

import Foundation

enum PlayerModel {
    case grandPa
    case grandMa
    case none
    
    // 現在のターンに応じたメッセージ
    var whoseTurnMessage: String {
        switch self {
        case .grandPa:
            return "おじいちゃんのターン！"
        case .grandMa:
            return "おばあちゃんのターン！"
        default:
            return " "
        }
    }
    
    // アラートメッセージ
    var alertMessage: String {
        switch self {
        case .grandPa:
            return "おじいちゃん勝利！！！"
        case .grandMa:
            return "おばあちゃん勝利！！！"
        default:
            return "引き分け！！！"
        }
    }
    
    // ユーザを切り替える
    mutating func togglePlayer() {
        switch self {
        case .grandPa:
            self = .grandMa
        case .grandMa:
            self = .grandPa
        default:
            self = .none
        }
    }
    
    // 文字列に変換する
    func toString() -> String {
        switch self {
        case .grandPa:
            return "ojiichan"
        case .grandMa:
            return "obaachan"
        default:
            return ""
        }
    }
    
    // 先手をお知らせするメッセージ
    var firstTurnMessage: String {
        switch self {
        case .grandPa:
            return "先手：おじいちゃん"
        case .grandMa:
            return "先手：おばあちゃん"
        default:
            return "先手プレイヤーをタップだ！"
        }
    }
}
