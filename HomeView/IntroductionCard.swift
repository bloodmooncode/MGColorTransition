//
//  SwiftUIView.swift
//  
//
//  Created by 张原溥 on 2022/4/21.
//

import SwiftUI

struct IntroductionCard: View {
    @Binding var isIntro : Bool
    
    var body: some View {
        
        ZStack {
//            Color.primary.edgesIgnoringSafeArea(.all)
            ZStack {
                Color("Introduction")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack {
                        Button(action: {
                            isIntro = false
                        }, label: {
                            Image(systemName: "chevron.backward.2")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                        })
                        
                        Spacer()
                        
                        Text("About the App")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    
                    Image("Introduction")
                        .scaleEffect(2)
                }
            }
            
            VStack {
                Text("This software is mainly used to assist the production of MG animation transitions. MG animations are often colorful and have many page switches. It is troublesome to manually create animations every time. This software can automatically extract the average color of  two different animation segments, add color transitions, merge and export them. ")
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

