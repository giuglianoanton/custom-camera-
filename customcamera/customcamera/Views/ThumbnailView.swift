//
//  ThumbnailView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 22/11/22.
//

import SwiftUI

struct ThumbnailView: View {
    
    var photo: [UIImage]
    
    var body: some View {
        Image(uiImage: photo.first!)
                .resizable()
                .frame(width: 70, height: 70)
                .scaledToFill()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
    
    }
    
}
