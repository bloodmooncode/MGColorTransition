//
//  SwiftUIView.swift
//  
//
//  Created by 张原溥 on 2022/4/20.
//

import SwiftUI

struct MergeVideoCard: View {
    @Binding var isMergeVideo : Bool
    
    var body: some View {
        
        ZStack {
//            Color.primary.edgesIgnoringSafeArea(.all)
            ZStack {
                Color("MergeVideo")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack {
                        Button(action: {
                            isMergeVideo = false
                        }, label: {
                            Image(systemName: "chevron.backward.2")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                        })
                        
                        Spacer()
                        
                        Text("Merge Video")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    
                    Image("Merge Video")
                        .scaleEffect(2)
                }
            }
            
            VStack {
                Text("Merge Videos is the last step, at this time you have got your transition animation connecting the first video with  the second one. This time you can choose a video queue which containing basic two or more to merge them together. Remember to click on the button merge to carry it out, after which you can see the preview and save it to local directory.")
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
