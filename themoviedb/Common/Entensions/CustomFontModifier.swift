//
//  CustomFontModifier.swift
//  themoviedb
//
//  Created by ENT21041868 on 23/11/2023.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    var weight: Font.Weight
    var size: CGFloat

    func body(content: Content) -> some View {
            switch weight {
            case .bold:
                return content.font(.custom("Montserrat-Bold", size: size))
            case .medium:
                return content.font(.custom("Montserrat-Medium", size: size))
            case .regular:
                return content.font(.custom("Montserrat-Regular", size: size))
            case .semibold:
                return content.font(.custom("Montserrat-SemiBold", size: size))
            default:
                return content.font(.custom("Montserrat-Regular", size: size))
            }
        }
}

extension View {
    func customFont(weight: Font.Weight, size: CGFloat) -> some View {
        return self.modifier(CustomFontModifier(weight: weight, size: size))
    }
}
