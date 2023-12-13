//
//  SwiftUIView.swift
//  
//
//  Created by 张原溥 on 2022/4/20.
//

import SwiftUI

struct GenerateMGCard: View {
    @Binding var isGenerateMG : Bool
    
    var body: some View {
        ZStack {
//            Color.primary.edgesIgnoringSafeArea(.all)
            ZStack {
                Color("GenerateMG")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack{
                        Button(action: {
                            isGenerateMG = false
                        }, label: {
                            Image(systemName: "chevron.backward.2")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                        })
                        Spacer()
                        Text("Generate MG")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Image("Generate MG")
                        .scaleEffect(2)
                }
            }
            
            VStack {
                Text("Generate MG is the second step. If you arrive this page directly, you can see six preset color transition effects. If you follow the steps, you can get the two main colors from previous two videos and an average color between them. Click on the activate button, you can notice that the colorful animation have been changed automatically. Then you can choose one and hidden page button to record the screen.")
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
