//
//  ContentView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import SwiftUI
import Photos

struct ContentView: View {
    var allPhotos : PHFetchResult<PHAsset>? = nil
    
    var body: some View {
        CameraView()
            
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
