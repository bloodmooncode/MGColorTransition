//
//  SwiftUIView.swift
//  
//
//  Created by 张原溥 on 2022/4/21.
//

import SwiftUI

struct LoadView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if colorScheme == .light {
            SwiftUIGIFPlayerView(gifName: "LoadLight")
        } else {
            SwiftUIGIFPlayerView(gifName: "LoadDark")
        }
    }
}

