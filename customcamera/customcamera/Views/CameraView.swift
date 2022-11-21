//
//  CameraView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 21/11/22.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var cameraBack = CameraBackModel()
    @StateObject var cameraFront = CameraFrontModel()
    @State var isSwitched = false
    @State var isFlashOn = false
    @State var flash = "bolt.slash.fill"
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
                                print(cameraBack.flashMode)
                            }else{
                                cameraBack.flashMode = .off
                                print(cameraBack.flashMode)
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
                }
                Spacer()
            HStack{
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "square.fill")
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
                })
                
                Spacer()
                Button(action: {
                    if isSwitched{
                        cameraFront.takePhoto()
                        //cameraFront.savePhoto()
                        cameraFront.retakePhoto()
                    }else{
                        cameraBack.takePhoto()
//                        cameraBack.savePhoto()
                        cameraBack.retakePhoto()
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

