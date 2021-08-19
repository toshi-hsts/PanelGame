//
//  FirstPlayerMessageModel.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/19.
//

import Foundation

enum FirstPlayerModel {
    case grandPa
    case grandMa
    case none
    
    var message: String {
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
