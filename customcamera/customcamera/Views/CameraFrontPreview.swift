//
//  CameraFrontPreview.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import SwiftUI
import AVFoundation

struct CameraFrontPreview: UIViewRepresentable {
    
    @ObservedObject var cameraFront: CameraFrontModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        cameraFront.preview = AVCaptureVideoPreviewLayer(session: cameraFront.session)
        cameraFront.preview.frame = view.frame
        
        cameraFront.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraFront.preview)
        
//        cameraFront.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
