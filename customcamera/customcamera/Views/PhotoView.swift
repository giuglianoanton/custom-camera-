//
//  PhotoView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 23/11/22.
//

import SwiftUI

struct PhotoView: View {

//    @Binding var photo: [UIImage]
    @Binding var photo: CGImage
    
    var body: some View {
        
//        Image(uiImage: photo.first!)
        Image(uiImage: UIImage(cgImage: photo))
                .resizable()
                .frame(width: 500, height: 500)
                .scaledToFill()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
    
    }
    
}
//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView()
//    }
//}
