//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/20.
//

import SwiftUI

struct PickVideoCard: View {
    @Binding var isPickMedia : Bool
    var body: some View {
        
        ZStack {
//            Color.primary.edgesIgnoringSafeArea(.all)
            ZStack {
                Color("PickMedia")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack {
                        Button(action: {
                            isPickMedia = false
                        }, label: {
                            Image(systemName: "chevron.backward.2")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                        })
                        
                        Spacer()
                        
                        Text("Pick Media")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    
                    Image("Pick Media")
                        .scaleEffect(2)
                }
            }
            
            VStack {
                Text("Pick Video is the first step, in which you can see the select button, you may choose only two videos from your album, and the aspect ratio of them should be sixteen to nine, otherwise the app may not work properly. Then press the extract button and then you’ ll see two video tracks, drag the progress bar to select one keyframe and the app will extract the main colors of these two videos automatically. ")
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
    }
}

