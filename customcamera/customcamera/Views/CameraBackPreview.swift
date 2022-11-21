//
//  CameraPreviewView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import SwiftUI
import AVFoundation

struct CameraBackPreview: UIViewRepresentable {
    
    @ObservedObject var cameraBack: CameraBackModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        cameraBack.preview = AVCaptureVideoPreviewLayer(session: cameraBack.session)
        cameraBack.preview.frame = view.frame
        
        cameraBack.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraBack.preview)
        
//        cameraBack.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}




