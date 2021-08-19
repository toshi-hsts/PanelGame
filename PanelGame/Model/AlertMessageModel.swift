//
//  AlertMessageModel.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/19.
//

import Foundation

enum AlertMessageModel {
    case winGrandPa
    case winGrandMa
    case draw
    case none
    
    var message: String {
        switch self {
        case .winGrandPa:
            return "おじいちゃん勝利！！！"
        case .winGrandMa:
            return "おばあちゃん勝利！！！"
        case .draw:
            return "引き分け！！！"
        default:
            return ""
        }
    }
}
