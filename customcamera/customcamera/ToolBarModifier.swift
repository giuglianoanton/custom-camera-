//
//  ToolBarModifier.swift
//  customcamera
//
//  Created by Antonella Giugliano on 24/11/22.
//

import Foundation
import SwiftUI

struct ToolBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UIToolbarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
//        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
//        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UIToolbar.appearance().standardAppearance = coloredAppearance
        UIToolbar.appearance().compactAppearance = coloredAppearance
        UIToolbar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {

    func toolBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(ToolBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}
