//
//  CameraBackModel.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import Foundation
import SwiftUI
import AVFoundation


class CameraBackModel:NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    
    
    //@Published var isTaken = false
    
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
    @Published var currentFlashMode = "off"
    
    
//    @Published var input: AVCaptureDeviceInput!
    
    @Published var isSaved = false
    
    //data of taken photo
    @Published var picData = Data(count: 0)
    
    
    @Published var flashMode: CurrentFlashMode = .off
    
    //type of flash
    enum CurrentFlashMode {
        case off
        case on
        case auto
        
    }

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
    
    //set Device among all devices available
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
        
       self.device = availableCaptureDevices[0]
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
            
            let input = try AVCaptureDeviceInput(device: self.device)
            //to enable the highest resolution
            self.output.isHighResolutionCaptureEnabled = true
            
//            var photoQualityPrioritization: AVCapturePhotoOutput.QualityPrioritization = .quality
//            self.output.maxPhotoQualityPrioritization = photoQualityPrioritization
            
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
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
    // get settings for the photo, settings have to be init at each shooting
    func getSettings(camera: AVCaptureDevice, flashMode: CurrentFlashMode) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
//        let presetSession = AVCaptureSession.Preset(rawValue: AVAssetExportPreset3840x2160)
//        let rawFormat = output.availableRawPhotoPixelFormatTypes.first
//        settings = AVCapturePhotoSettings(rawPixelFormatType: OSType(rawFormat!))

//        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
//        settings.rawPhotoPixelFormatType
//        let settings = AVCapturePhotoSettings(rawPixelFormatType: OSType(self.photoOutput!.availableRawPhotoPixelFormatTypes[0]), processedFormat: nil)
        
        //saving uncompressed
//        let bgraFormat: [String: AnyObject] = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        //print(self.output.availablePhotoPixelFormatTypes)
//        let settings = AVCapturePhotoSettings(format: bgraFormat)
        if camera.hasFlash {
            switch flashMode {
               case .auto: settings.flashMode = .auto
               case .on: settings.flashMode = .on
               default: settings.flashMode = .off
            }
        }
        
        return settings
    }
    
    //take photo
    func takePhoto(){

        DispatchQueue.global(qos: .background).async {
            
//            var photoQualityPrioritization: AVCapturePhotoOutput.QualityPrioritization = .quality
            
            let settings = self.getSettings(camera: self.device, flashMode: self.flashMode)
//            settings.photoQualityPrioritization = photoQualityPrioritization
            settings.isHighResolutionPhotoEnabled = true
            self.output.capturePhoto(with: settings, delegate: self)
//            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            //self.session.stopRunning()
            print("takephoto")
//            DispatchQueue.main.async {
//                let settings = self.getSettings(camera: self.device, flashMode: self.flashMode)
//                self.output.capturePhoto(with: settings, delegate: self)
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {
                    timer in self.session.stopRunning()
                }
                //withAnimation{self.isTaken.toggle()}
//            }
        }
    }
    
    
    //retake ph once the pic is saved
    func retakePhoto(){

            
        DispatchQueue.global(qos: .background).async{
                //self.session.startRunning()
                
                DispatchQueue.main.async{
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {
                    timer in self.session.startRunning()
                }
//                    withAnimation{self.isTaken.toggle()}
//                    self.isSaved = false
                }
            }
        }
 
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print(photo)
        if error != nil {
            return
        }
        print("photoOutput succeded")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        print(imageData)
        self.picData = imageData
        print(imageData)
        let image = UIImage(data: self.picData)!
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.isSaved = true
        print("savePhoto succeded")
    }
    
    //save photo
    func savePhoto(){
//        DispatchQueue.global(qos: .background).async{
      Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {
        timer in
            let image = UIImage(data: self.picData)!
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.isSaved = true
            print("savePhoto succeded")

//        }
        }
    }
    
    
}

