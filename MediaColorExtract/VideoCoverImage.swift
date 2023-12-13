//
//  File 2.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/17.
//

import SwiftUI 

struct VideoCoverImage : View {
    
    @Binding var currentCoverImage: UIImage?
    @Binding var extract: Bool
    @Binding var selectedColor : Color
    @Binding var colorsMix: [Color]
    @Binding var isClear :Bool
    
    var body : some View {
        
        VStack{
        if let currentCoverImage = currentCoverImage {
            Image(uiImage: currentCoverImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 100, height: (UIScreen.main.bounds.width - 100) * (9 / 16))
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.primary ,lineWidth: 2))
            
        }
        
//                selectedColor = Color(currentCoverImage?.averageColor ?? .clear)
        
            ColorPicker(selection: $selectedColor, label: {
                Text("The average color extracted from the above image")
                    .foregroundColor(.primary)
            })
            
            .onAppear {
                self.setAverageColor()
                if colorsMix.count > 2{
                    colorsMix.removeAll()
                } else {
                    colorsMix.append(selectedColor)
                }
            }
            .font(.system(size: 18,weight: .bold, design: .default))
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 130, height: 60, alignment: .center)
            .padding()
            .background(Color("purple").opacity(0.5))
            
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.primary,lineWidth: 2))
            
        }
    }
    
    func setAverageColor() {
        let SelectedColor = currentCoverImage?.averageColor
        selectedColor = Color(SelectedColor ?? .clear)
    }
}
