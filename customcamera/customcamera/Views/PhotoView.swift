//
//  PhotoView.swift
//  customcamera
//
//  Created by Antonella Giugliano on 23/11/22.
//

import SwiftUI
import UIKit

struct PhotoView: View {
    
    var photo: CGImage
    
    var body: some View {
        ScrollView{
            //        Image(uiImage: photo.first!)
            Image(uiImage: UIImage(cgImage: photo))
                .resizable()
                .rotationEffect(Angle(degrees: 90))
                .frame(width: 500, height: 500)
                .scaledToFill()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 50, trailing: 0))
        }
//        .navigationTitle()
        .navigationBarColor(backgroundColor: UIColor(named: "navigationbar"), titleColor: .white)
        
        //navigationbar buttons
        .toolbar{
            //all photos
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {

                }, label: {
                    Text("All Photos")
                })
            }
            //contextualmenu
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {

                }, label: {
                    Image(systemName: "ellipsis.circle")
                })
            }
            
        }
        
        //bottom toolbar
            .toolbar(content: {
            
            //share
            ToolbarItem(placement: .bottomBar) {
                Button(action: {

                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            //favorite
            ToolbarItem(placement: .bottomBar) {
                Button(action: {

                }, label: {
                    Image(systemName: "heart")
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            //info
            ToolbarItem(placement: .bottomBar) {
                Button(action: {

                }, label: {
                    Image(systemName: "info.circle")
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            //edit
            ToolbarItem(placement: .bottomBar) {
                Button(action: {

                }, label: {
                    Text("Edit")
                        .font(.system(size: 20))
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            //delete
            ToolbarItem(placement: .bottomBar) {
                Button(action: {

                }, label: {
                    Image(systemName: "trash")
                })
            }
            })
    }
    
}
