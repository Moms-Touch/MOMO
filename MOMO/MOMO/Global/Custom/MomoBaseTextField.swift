//
//  MoMoBaseTextField.swift
//  MOMO
//
//  Created by Woochan Park on 2021/10/04.
//

import UIKit

final class MomoBaseTextField: UITextField {
    private let figMaDefinedWidthValue: CGFloat = 295
    private let figMaDefinedHeightValue: CGFloat = 47
    
    init() {
        super.init(frame: CGRect())
        applyMoMoDesign()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyMoMoDesign()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyMoMoDesign()
    }
    
    private func applyMoMoDesign() {
        self.borderStyle = .none
        self.layer.cornerRadius = figMaDefinedHeightValue / 2
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        self.setBorderColor(to: .white)
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.textRect(forBounds: CGRE)
        self.heightAnchor.constraint(equalToConstant: figMaDefinedHeightValue).isActive = true
        self.widthAnchor.constraint(equalToConstant: figMaDefinedWidthValue).isActive = true
    }
    
    internal func setBorderColor(to color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
}
