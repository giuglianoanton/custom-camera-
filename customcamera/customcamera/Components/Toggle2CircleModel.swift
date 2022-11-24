//
//  Toggle2CircleModel.swift
//  customcamera
//
//  Created by Antonella Giugliano on 24/11/22.
//

import Foundation
import SwiftUI

struct Toggle2Circle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                ZStack{
                    Rectangle()
                        .fill(Color.black)
                        .opacity(0.2)
                        .frame(width: 85, height: 50)
                        .cornerRadius(50)
                        
                    
                HStack{
                    ZStack{
                        Circle()
                            .fill(Color.black)
                            .opacity(0.4)
                            .frame(width: configuration.isOn ? 40 : 20, height: configuration.isOn ? 40 : 20)
                        Text(configuration.isOn ? "0,5x" : "0,5")
                            .foregroundColor(configuration.isOn ? .yellow : .white)
                            .font(.system(size: configuration.isOn ? 16 : 12))
                            .bold()
                            .frame(width: configuration.isOn ? 40 : 20, height: configuration.isOn ? 40 : 20)
                    }
                    
                    ZStack{
                        Circle()
                            .fill(Color.black)
                            .opacity(0.4)
                            .frame(width: configuration.isOn ? 20 : 40, height: configuration.isOn ? 20 : 40)
                        Text(configuration.isOn ? "1" : "1x")
                            .foregroundColor(configuration.isOn ? .white : .yellow)
                            .font(.system(size: configuration.isOn ? 12 : 16))
                            .bold()
                            .frame(width: configuration.isOn ? 20 : 40, height: configuration.isOn ? 20 : 40)
                    }
                }.frame(width: 85)
            }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
