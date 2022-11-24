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
    @StateObject var camera = CameraModel()
    @State var isSwitched = false
    @State var isFlashOn = false
    @State var flash = "bolt.slash.fill"
   
    //with the fetching stuff
//    enum typeCamera {
//        case void
//        case back
//        case front
//    }
//    @State var lastToShoot: typeCamera = .void
//    @State var lastPhoto: UIImage = UIImage()
//    @State var temp1 = 1
//    @State var temp2 = 2
//    @State var tempHasChanged = false
//
//
//    @State var thumbnail: [UIImage] = [UIImage]()
//
//
//
//    @State var allPhotos : PHFetchResult<PHAsset>? = nil
//    @State var fetchedPhotos = [UIImage]()
    
    
    var body: some View {
        NavigationView{
        ZStack{
            if isSwitched{
                
                ZStack{
                    CameraPreview(camera: camera)
                        .ignoresSafeArea(.all, edges: .all)
                    Text("is")
                }
                
            } else{
                ZStack{
                CameraPreview(camera: camera)
                    .ignoresSafeArea(.all, edges: .all)
                    .onAppear(perform: {
                        camera.checkPermissions()
//                        updateLastPhoto()
                        
                    })
                    Text("isnot")
            }
            }
            //up and bottom buttons
            VStack{
                //up buttons
                
                ZStack {
                    HStack{
                        
                        if !isSwitched{
                            //flasButton
                            Button(action: {
                                
                                self.isFlashOn.toggle()
                                if isFlashOn{
                                    camera.flashMode = .on
                                    
                                }else{
                                    camera.flashMode = .off
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
                        }
                        //Compressed file button
                            Button(action: {
                                
                                camera.isCompressed.toggle()
                                
                                
                            }, label: {
                                ZStack{
                                    
                                    Circle()
                                        .stroke(Color.white, lineWidth: 0.5)
                                        .frame(width: 25, height: 25)
                                    if camera.isCompressed{
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
                        
                        Spacer()
                      
                        //live pic not active for now
                        Button(action: {},label: {
                                Image(systemName: "livephoto")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                        })
                    }

                    Button(action: {},label: {
                        ZStack{
                            Circle()
                                .foregroundColor(Color.gray)
                                .opacity(0.2)
                                .frame(width: 25, height: 25)
                            
                            Image(systemName: "chevron.up")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    })
                }.frame(height: 60)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                .background(Color.black)
                
                Spacer()
                //bottom buttons
                ZStack {
                    HStack{
                        //thumbnails
                        if !camera.isSaved{
                            Image(systemName: "photo")
                                .font(.system(size: 39))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
                        }else{
                            NavigationLink(destination: PhotoView(photo: $camera.photoPreview), label: {
                                    Image(uiImage: UIImage(cgImage: camera.photoPreview!))
                                        .resizable()
                                        .scaledToFit()
                                        .rotationEffect(Angle(degrees: 90))
                                        .frame(width: 55, height: 55)
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))

                            })
                        }
                        
                        Spacer()
                        Button(action: {
                            isSwitched.toggle()
                            camera.switchCamera()
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
                        
                    }
                    Button(action: {
//                        i
//                            checkTempHasChanged()
//                            lastToShoot = .back
                            camera.shoot()
                            
                        //with the fetching stuff
//                            temp2 = 2
//                            checkTempHasChanged()
//                            tempHasChanged.toggle()
//                            tempHasChanged.toggle()
                            
//                            cameraBack.isSaved.toggle()
//                        }
                        
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
                  
                }.frame(height: 120)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                 .background(Color.black)
            }
            
        }
        
//        .navigationBarColor(backgroundColor: .black, titleColor: .white)
        .toolBarColor(backgroundColor: UIColor(named: "toolbar"), titleColor: .white)
        }//needed to see the toolbar in the navigationLink
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
    
    //with the fetching stuff
//    func updateThumbnail(){
//        if lastToShoot == .void{
//
//        }
//    }
    
    //with the fetching stuff
//    func updateLastPhoto() {
//        var startFetchedPhotos = Thumbnail()
//        startFetchedPhotos.getAllPhotos()
//        fetchedPhotos = startFetchedPhotos.allPhotos
//        print(fetchedPhotos.count)
//        Task{
//            if camera.isSaved{
//                await camera.retakePhoto()
//            }
//        }
//        if lastToShoot == .void{
//            return
//        }
//        else{
//            if fetchedPhotos.count > 0{
//                lastPhoto = (fetchedPhotos.first)!
//                temp1 = 1
//                temp2 = temp1
//            }
//            else{
//                return
//            }
//        }
//
//        return
//    }
    
    //with the fetching stuff
//    func checkTempHasChanged() {
//        if temp1 != temp2{
//            tempHasChanged = true
//            print(true)
//        }
//        else{
//            tempHasChanged = false
//            print(false)
//        }
//    }
 
    
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
