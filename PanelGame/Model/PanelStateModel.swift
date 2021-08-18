//
//  PanelStateModel.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/16.
//

import Foundation

enum PanelStateModel {
    case grandPa
    case grandMa
    case none
    
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
}
