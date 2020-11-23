//
//  UILabel+Factory.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 22/11/2020.
//

import UIKit

enum LabelStyle {
    case timelineIndicator
    
    var textColor: UIColor {
        switch self {
        case .timelineIndicator:
            return UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    var font: UIFont {
        switch self {
        case .timelineIndicator:
            return UIFont.systemFont(ofSize: 10)
        }
    }
}

extension UILabel {
    static func with(style: LabelStyle) -> UILabel {
        let label = UILabel()
        label.textColor = style.textColor
        label.font = style.font
        return label
    }
}
