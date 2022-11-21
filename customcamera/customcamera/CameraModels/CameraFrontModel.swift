//
//  CameraFrontModel.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraFrontModel:NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    
    
    private var photoOutput: AVCapturePhotoOutput?
    
    @Published var isTaken = false
    
    //initialize a capture session
    @Published var session = AVCaptureSession()
    
    //alert for permission
    @Published var permissionAlert = false
    
    //to handle the data and read them as photo
    @Published var output = AVCapturePhotoOutput()
    
    //for the preview of the camera
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var availableCaptureDevices: [AVCaptureDevice]!
    
    @Published var device: AVCaptureDevice!
    
    @Published var isBackCameraOn = true
    
    
//    @Published var input: AVCaptureDeviceInput!
    
    @Published var isSaved = false
    
    //data of taken photo
    @Published var picData = Data(count: 0)
    
    
    //check the permissions
    func checkPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
            case .authorized:
                //set session cause it has permissions
                setDevice()
                setSession()
                return
                
            case .notDetermined:
                //requesting permission before setting the session
                AVCaptureDevice.requestAccess(for: .video) {
                    (status) in
                    if status{
                        self.setSession()
                    }
                }
                
            case .denied:
                //does not have permission
                self.permissionAlert.toggle()
                return
                
            default:
                return
        }
    }
    
    func setDevice(){
        var allCaptureDevices: [AVCaptureDevice] {
            AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera, .builtInDualWideCamera], mediaType: .video, position: .unspecified).devices
        }
        self.availableCaptureDevices = {
            captureDevices
                .filter( { $0.isConnected } )
                .filter( { !$0.isSuspended } )
        }()
        var frontCaptureDevices: [AVCaptureDevice] {
            allCaptureDevices
                .filter { $0.position == .front }
        }
        var backCaptureDevices: [AVCaptureDevice] {
            allCaptureDevices
                .filter { $0.position == .back }
        }
        var captureDevices: [AVCaptureDevice] {
            var devices = [AVCaptureDevice]()
            #if os(macOS) || (os(iOS) && targetEnvironment(macCatalyst))
            devices += allCaptureDevices
            #else
            if let backDevice = backCaptureDevices.first {
                devices += [backDevice]
            }
            if let frontDevice = frontCaptureDevices.first {
                devices += [frontDevice]
            }
            #endif
            return devices
        }
        var availableCaptureDevices: [AVCaptureDevice] {
            captureDevices
                .filter( { $0.isConnected } )
                .filter( { !$0.isSuspended } )
        }
        
       self.device = availableCaptureDevices[1]
    }
   
    //setting the session is allowed only if permissions have been provided
    func setSession(){
        do{
            //start the configuration
            
            self.session.beginConfiguration()
            
            // store the capture device
            //devicetype for iphone13 .builtInUltraWideCamera
            //let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .unspecified)
            
            //store the input from this device
            //let input = try AVCaptureDeviceInput(device: self.device)
            let input = try AVCaptureDeviceInput(device: self.device)
            //if an input can be added to the session, then add that input to the session
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            //if an output can be added to the session, then add that output to the session
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            //close the configuration
            self.session.commitConfiguration()
            
            //had hang risk purple alert saying it has to be calledd background
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
    //take photo
    func takePhoto(){

        DispatchQueue.global(qos: .background).async {

            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            //self.session.stopRunning()

            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {
                    timer in self.session.stopRunning()
                }
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    
    //retake ph
    func retakePhoto(){
        
        DispatchQueue.global(qos: .background).async{
            //self.session.startRunning()
            
            DispatchQueue.main.async{
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {
                timer in self.session.startRunning()
            }
                withAnimation{self.isTaken.toggle()}
                self.isSaved = false
            }
        }
    }
 
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        print("photoOutput succeded")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        self.picData = imageData
    }
    
    func savePhoto(){
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {
            timer in
            let image = UIImage(data: self.picData)!
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.isSaved = true
            print("savePhoto succeded")
            
        }
    }
}

