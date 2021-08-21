//
//  RoundedRectangle.swift
//  PanelGame
//
//  Created by ToshiPro01 on 2021/08/22.
//

import Foundation
import SwiftUI

//　RoundedRectangleのモディファイア拡張
extension RoundedRectangle {
    // 背景色をpanelよって変更する
    func changePanelColor(_ panelState: PanelStateModel) -> some View {
        var fillColor = self.fill(Color.white)
        if panelState == .grandPa{ fillColor =  self.fill(Color.blue) }
        if panelState == .grandMa{ fillColor = self.fill(Color.orange) }
        return fillColor
    }
}
