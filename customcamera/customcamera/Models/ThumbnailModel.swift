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
    @Published var allPhotos = [UIImage]()
    @Published var errorString : String = ""
   
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
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        let targetSize = CGSize(width: 700, height: 800)
//        or
//        let targetSize = PHImageManagerMaximumSize
        //but the bigger the slower
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func getAllPhotos() {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        //        self.count = results.count
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                self.allPhotos.append(getAssetThumbnail(asset: asset))
            }
        } else {
            self.errorString = "No photos to display"
        }
    }
}
