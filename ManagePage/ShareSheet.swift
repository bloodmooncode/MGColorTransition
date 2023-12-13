//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/16.
//

import SwiftUI

struct ShareSheet : UIViewControllerRepresentable {
    
    var items: [Any]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let view = UIActivityViewController(activityItems:items,applicationActivities: nil)
        return view
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
