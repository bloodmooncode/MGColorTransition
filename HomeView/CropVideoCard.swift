//
//  SwiftUIView 2.swift
//  
//
//  Created by 张原溥 on 2022/4/20.
//

import SwiftUI

struct CropVideoCard: View {
    @Binding var isCropVideo : Bool
    var body: some View {
        
        ZStack {
//            Color.primary.edgesIgnoringSafeArea(.all)
            ZStack {
                Color("CropVideo")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack {
                        Button(action: {
                            isCropVideo = false
                        }, label: {
                            Image(systemName: "chevron.backward.2")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                        })
                        
                        Spacer()
                        
                        Text("Crop Video")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    
                    Image("Crop Video")
                        .scaleEffect(2)
                }
            }
            
            VStack {
                
                Text("Crop Video is the third step, which is used for cropping the color transition video which was originally in 4:3 aspect ratio, just like the screen size of ipad. we choose the video that you have recorded in the former step, then click on the export video having regular style of 1920 * 1080 to your album. At first you cannot see the export button but only an example video to teach you how to operate.")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .frame(width: UIScreen.main.bounds.width / 1.3)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color("Background").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .stroke(Color("Background"), lineWidth: 2)
                    )
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .bottom)
            
        }
    }}
