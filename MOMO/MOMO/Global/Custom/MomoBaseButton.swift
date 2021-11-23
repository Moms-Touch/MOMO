//
//  MomoBaseButton.swift
//  MOMO
//
//  Created by 오승기 on 2021/11/23.
//

import UIKit

class MomoBaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyMoMoButtonDesign()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyMoMoButtonDesign()
    }
    
    private func applyMoMoButtonDesign() {
        layer.cornerRadius = 4
        backgroundColor = Asset.Colors.pink4.color
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
    }
}
