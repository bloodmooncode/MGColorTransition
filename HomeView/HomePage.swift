//
//  File 2.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/17.
//

import SwiftUI

struct HomePage : View {
    @Environment(\.colorScheme) var colorScheme
    @State var isPickMedia = false
    @State var isGenerateMG = false
    @State var isCropVideo = false
    @State var isMergeVideo = false
    @State var isIntro = false
    @State private var animationAmount = 1.0
    
    var body: some View{
        ZStack {
            Color("Background").blur(radius: 100)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack{
                    if colorScheme == .light {
                        Image("HomeLight")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 200, height: (UIScreen.main.bounds.width - 200) * 0.6)
                            .padding(.top,50)
                    } else {
                        Image("HomeDark")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 200, height: (UIScreen.main.bounds.width - 200) * 0.6)
                            .padding(.top,50)
                    }
                    VStack {
                        HStack{
                            Spacer()
                            Image("Profile")
                                .scaleEffect(0.6)
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 100)
                }
                Spacer()
                
                Text("Click on the card below to learn how to use the app.")
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(Color("purple"))
                Spacer()
                
                
                ScrollView (.horizontal,showsIndicators: false){
                    HStack(spacing: 20) {
                        
                        Button (action: {
                            isIntro = true
    //                        print("\(isPickMedia)")
                        }, label: {
                            ZStack {
                                Color("Introduction")
                                VStack{
                                    Spacer()
                                    
                                    Image("Introduction")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                                        .mask(
                                                Rectangle()
                                                    .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 4)
                                                    .offset(y: -50)
                                        )
                                }
                                .frame(height:UIScreen.main.bounds.width / 1.5)
                                
                                VStack{
                                    Text("Introduction")
                                        .font(.system(size: 30))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                }
                                .frame(height:UIScreen.main.bounds.width / 3)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .fullScreenCover(isPresented: $isIntro){
                            IntroductionCard(isIntro: $isIntro)
                                .transition(.move(edge: .trailing))
                                .animation(
                                    .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: false),
                                    value: animationAmount
                                )
                        }
                        
                        Button (action: {
                            isPickMedia = true
    //                        print("\(isPickMedia)")
                        }, label: {
                            ZStack {
                                Color("PickMedia")
                                VStack{
                                    Spacer()
                                    
                                    Image("Pick Media")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                                        .mask(
                                                Rectangle()
                                                    .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 4)
                                                    .offset(y: -50)
                                        )
                                }
                                .frame(height:UIScreen.main.bounds.width / 1.5)
                                
                                VStack{
                                    Text("Pick Media")
                                        .font(.system(size: 30))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                }
                                .frame(height:UIScreen.main.bounds.width / 3)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .fullScreenCover(isPresented: $isPickMedia){
                            PickVideoCard(isPickMedia: $isPickMedia)
                                .transition(.move(edge: .trailing))
                                .animation(
                                    .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: false),
                                    value: animationAmount
                                )
                        }
                        
                        Button(action: {
                            isGenerateMG = true
                        }, label: {
                            ZStack {
                                Color("GenerateMG")
                                VStack{
                                    Spacer()
                                    
                                    Image("Generate MG")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                                        .mask(
                                                Rectangle()
                                                    .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 4)
                                                    .offset(y: -50)
                                        )
                                }
                                .frame(height:UIScreen.main.bounds.width / 1.5)
                                
                                VStack{
                                    Text("Generate MG")
                                        .font(.system(size: 30))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                }
                                .frame(height:UIScreen.main.bounds.width / 3)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .fullScreenCover(isPresented: $isGenerateMG) {
                            GenerateMGCard(isGenerateMG: $isGenerateMG)
                                .transition(.move(edge: .trailing))
                                .animation(
                                    .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: false),
                                    value: animationAmount
                                )
                        }
                        
                        Button(action: {
                            isCropVideo = true
                        }, label: {
                            ZStack {
                                Color("CropVideo")
                                VStack{
                                    Spacer()
                                    
                                    Image("Crop Video")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                                        .mask(
                                                Rectangle()
                                                    .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 4)
                                                    .offset(y: -50)
                                        )
                                }
                                .frame(height:UIScreen.main.bounds.width / 1.5)
                                
                                VStack{
                                    Text("Crop Video")
                                        .font(.system(size: 30))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                }
                                .frame(height:UIScreen.main.bounds.width / 3)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .fullScreenCover(isPresented: $isCropVideo) {
                            CropVideoCard(isCropVideo: $isCropVideo)
                                .transition(.move(edge: .trailing))
                                .animation(
                                    .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: false),
                                    value: animationAmount
                                )
                        }
                        
                        Button(action: {
                            isMergeVideo = true
                        }, label: {
                            ZStack {
                                Color("MergeVideo")
                                VStack{
                                    Spacer()
                                    
                                    Image("Merge Video")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                                        .mask(
                                                Rectangle()
                                                    .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 4)
                                                    .offset(y: -50)
                                        )
                                }
                                .frame(height:UIScreen.main.bounds.width / 1.5)
                                
                                VStack{
                                    Text("Merge Video")
                                        .font(.system(size: 30))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                }
                                .frame(height:UIScreen.main.bounds.width / 3)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3,height:UIScreen.main.bounds.width / 2.5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .fullScreenCover(isPresented: $isMergeVideo) {
                            MergeVideoCard(isMergeVideo: $isMergeVideo)
                                .transition(.move(edge: .trailing))
                                .animation(
                                    .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: false),
                                    value: animationAmount
                                )
                        }
                    }
                    .padding(.leading, 50)
                }
                .frame(height: UIScreen.main.bounds.width / 2.5)
                
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height - 200,alignment: .top)
        }
    }
}
