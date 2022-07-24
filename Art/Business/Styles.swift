//
//  Styles.swift
//  Art
//
//  Created by Alina Kharunova on 22.07.2022.
//

import Foundation
import UIKit

enum TextStyle {

    // MARK: - SF Pro Text 16

    case R16Black
    case SB16Black
    case B16Black
    
    // MARK: - Default
    
    case undefined

    var style: (font: UIFont, color: UIColor) {
        switch self {

            // MARK: - SF Pro 16

        case .R16Black: return (Fonts.R16, UIColor.black)
        case .SB16Black: return (Fonts.SB16, UIColor.black)
        case .B16Black: return (Fonts.B16, UIColor.black)

            // MARK: - Default

        case .undefined: return (Fonts.R16, UIColor.black)
        }
    }

    var font: UIFont {
        return style.font
    }

    var color: UIColor {
        return style.color
    }
}

