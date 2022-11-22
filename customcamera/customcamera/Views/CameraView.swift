//
//  CameraView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import SwiftUI
import AVFoundation
import Photos
 

struct CameraView: View {
    @StateObject var cameraBack = CameraBackModel()
    @StateObject var cameraFront = CameraFrontModel()
    @State var isSwitched = false
    @State var isFlashOn = false
    @State var flash = "bolt.slash.fill"
    @State var picData: CurrentPicData = .void
    enum CurrentPicData {
        case void
        case back
        case front
        
    }
    @State var allPhotos = Thumbnail()

    
    var body: some View {
        
        ZStack{
            if isSwitched{
                CameraFrontPreview(cameraFront: cameraFront)
                    .ignoresSafeArea(.all, edges: .all)
                    .onAppear(perform: {
                        cameraFront.checkPermissions()
                    })
                
            } else{
                
                CameraBackPreview(cameraBack: cameraBack)
                    .ignoresSafeArea(.all, edges: .all)
                    .onAppear(perform: {
                        cameraBack.checkPermissions()
                    })
            }
            VStack{
                HStack{
                    
                    if !isSwitched{
                        Button(action: {
                            
                            self.isFlashOn.toggle()
                            if isFlashOn{
                                cameraBack.flashMode = .on
                                
                            }else{
                                cameraBack.flashMode = .off
                                
                            }
                            
                            
                        }, label: {
                            ZStack{
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.5)
                                    .frame(width: 25, height: 25)
                                
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                
                                if !isFlashOn{
                                    Image(systemName: "line.diagonal")
                                        .rotationEffect(Angle(degrees: 90))
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                        })
                        
                        Button(action: {
                            
                            cameraBack.isCompressed.toggle()
                            
                            
                        }, label: {
                            ZStack{
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.5)
                                    .frame(width: 25, height: 25)
                                if cameraBack.isCompressed{
                                    Image(systemName: "rectangle.compress.vertical")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }else{
                                    Image(systemName: "rectangle.expand.vertical")
                                    
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                        })
                    }else{
                        Button(action: {
                            
                            cameraFront.isCompressed.toggle()
                            
                            
                        }, label: {
                            ZStack{
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.5)
                                    .frame(width: 25, height: 25)
                                if cameraFront.isCompressed{
                                    Image(systemName: "rectangle.compress.vertical")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }else{
                                    Image(systemName: "rectangle.expand.vertical")
                                    
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                        })
                    }
                }
                Spacer()
                HStack{
                    
                    Button(action: {
                        
                    }, label: {
                        if picData == .void{
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
                        
                        }
                        if cameraBack.isSaved || cameraFront.isSaved{
                                Image(uiImage: allPhotos.allPhotos.reversed()[0])
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .scaledToFill()
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
                            }
//                            else if cameraFront.isSaved {
//                                Image(uiImage: UIImage(data: createThumbnailData() as! Data)!)
//                                    .resizable()
//                                    .frame(width: 60, height: 60)
//                                    .scaledToFill()
//                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
//
//                            }
                            
                        
//
                    })
                    
                    Spacer()
                    Button(action: {
                        if isSwitched{
                            cameraFront.takePhoto()
                            
                            //cameraFront.savePhoto()
                            cameraFront.retakePhoto()
                            picData = .front
                            
                            
                            
                        }else{
                            cameraBack.takePhoto()
                            //cameraBack.savePhoto()
                        
                            cameraBack.retakePhoto()
                            picData = .back
                            
                        }
                        
                    }, label: {
                                   
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 70, height: 70)
                        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 0))
                        
                    })
                    
                    Spacer()
                    Button(action: {
                        isSwitched.toggle()
                    }, label: {
                        ZStack{
                            Image(systemName: "circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .opacity(0.2)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 10))
                            
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 10))
                        }
                    })
                    
                }.frame(height: 120)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.black)
            }
        
        }
        
    }
    func createBackThumbnailData() -> Data{
        var data: Data
        
            data = cameraBack.picData
            
            return data
        }
    
    
//        else if cameraFront.isSaved && picData == .front {
//            data = cameraFront.picData
//            cameraFront.isSaved.toggle()
//            return data
//        }
//        else{
//            return false
//        }
   
    
}

