//
//  ThumbnailModel.swift
//  customcamera
//
//  Created by Antonella Giugliano on 22/11/22.
//

import Foundation
import SwiftUI
import Photos

class Thumbnail: ObservableObject {
    
    @Published var cameraBack = CameraBackModel()
    @Published var cameraFront = CameraFrontModel()
    @Published var isTaken = false
     var temp = UIImage()
    
    @Published var thumbnail = UIImage()
    
    init(cameraBack: CameraBackModel, cameraFront: CameraFrontModel, isTaken: Bool = false, thumbnail: UIImage) {
        self.cameraBack = cameraBack
        self.cameraFront = cameraFront
        self.isTaken = isTaken
        self.thumbnail = thumbnail
    }
    
    func getThumbnail(){
            if cameraBack.isTaken {
                
                self.thumbnail = UIImage(data: cameraBack.picData)!
                
               
            }
            else if cameraFront.isTaken {
                
                self.thumbnail = UIImage(data: cameraFront.picData)!
                
               
            }
            self.temp = self.thumbnail
    }
//
    func resetTemp(){
        self.temp = UIImage()
    }
//    @Published var allPhotos = [UIImage]()
//    @Published var errorString : String = ""
//    var count: Int?


//    init() {
//        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
//            switch authorizationStatus {
//            case .authorized:
//                self.errorString = ""
//                self.getAllPhotos()
//            case .denied, .restricted:
//                self.errorString = "Photo access permission denied"
//            case .notDetermined:
//                self.errorString = "Photo access permission not determined"
//            case .limited:
//                self.errorString = "Photo access permission limited"
//            @unknown default:
//                fatalError()
//            }
//        }
//    }
//
//    fileprivate func getAllPhotos() {
//
//
//        let manager = PHImageManager.default()
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = false
//        requestOptions.deliveryMode = .highQualityFormat
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//        self.count = results.count
//        if results.count > 0 {
//            for i in 0..<results.count {
//                let asset = results.object(at: i)
//                let size = CGSize(width: 700, height: 700) //You can change size here
//                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
//                    if let image = image {
//                        self.allPhotos.append(image)
//                    } else {
//                        print("error asset to image")
//                    }
//                }
//            }
//
//        } else {
//            self.errorString = "No photos to display"
//        }
//
//
//
//}
}
