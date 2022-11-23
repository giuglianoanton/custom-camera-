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
   
    enum typeCamera {
        case void
        case back
        case front
    }
    @State var lastToShoot: typeCamera = .void
    @State var lastPhoto: UIImage = UIImage()
    @State var temp1 = 1
    @State var temp2 = 2
    @State var tempHasChanged = false
    

    @State var thumbnail: [UIImage] = [UIImage]()
    
    
    
    @State var allPhotos : PHFetchResult<PHAsset>? = nil
    @State var fetchedPhotos = [UIImage]()
    
    
    var body: some View {
        NavigationView{
        ZStack{
            if isSwitched{
                
                CameraFrontPreview(cameraFront: cameraFront)
                    .ignoresSafeArea(.all, edges: .all)
                    .onAppear(perform: {
                        cameraFront.checkPermissions()
                        updateLastPhoto()
                    })
                
            } else{
                
                CameraBackPreview(cameraBack: cameraBack)
                    .ignoresSafeArea(.all, edges: .all)
                    .onAppear(perform: {
                        cameraBack.checkPermissions()
                        updateLastPhoto()
                        
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
                    
//                    Button(action: {
                       
                    NavigationLink(destination: PhotoView(photo: $fetchedPhotos), label: {
                                                        
                            

                        
//                    }, label: {
                        if lastToShoot == .void{
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
                            
                        }
                        else {
                            if tempHasChanged{
                                
                                ThumbnailView(photo: fetchedPhotos)
                                    
                            }
                            else{
                               
                                ThumbnailView(photo: fetchedPhotos)

                            }
//                            ThumbnailView(photo: $lastPhoto)
//                                .onAppear{
//                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
//                                        if isSwitched{
//                                            lastPhoto = UIImage(data: cameraFront.picData) ?? UIImage()
//                                        }
//                                        else{
//                                            lastPhoto = UIImage(data: cameraBack.picData) ?? UIImage()
//                                        }
//                                    })

//                                }
                        }
                        
                        
                    })
                    
                    Spacer()
                    Button(action: {
                        if isSwitched{
//                            isTaken.toggle()
                            cameraFront.takePhoto()
                            
                            cameraFront.retakePhoto()
                            lastToShoot = .front
                            
                            
                            
                            //                            print("temp 0 \(temp) ")
                            
                        }else{
                            checkTempHasChanged()
                            cameraBack.shoot()
//                            cameraBack.takePhoto()
                            updateLastPhoto()
//                            thumbnail = getThumbnail()
                           
                            
//                            cameraBack.retakePhoto()
                            lastToShoot = .back
                            
                            temp2 = 2
//                            checkTempHasChanged()
                            tempHasChanged.toggle()
                            tempHasChanged.toggle()
                            
                           
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
        
    }
        
    
    
    func updateLastPhoto() {
        var startFetchedPhotos = Thumbnail()
        startFetchedPhotos.getAllPhotos()
        fetchedPhotos = startFetchedPhotos.allPhotos
        
        Task{
            if cameraBack.isSaved{
                await cameraBack.retakePhoto()
            }
        }
        if lastToShoot == .void{
            return
        }
        else{
            if fetchedPhotos.count > 0{
                lastPhoto = (fetchedPhotos.first)!
                temp1 = 1
                temp2 = temp1
            }
            else{
                return
            }
        }
        
        return
    }
    
    func checkTempHasChanged() {
        if temp1 != temp2{
            tempHasChanged = true
            print(true)
        }
        else{
            tempHasChanged = false
            print(false)
        }
    }
 
    
}

