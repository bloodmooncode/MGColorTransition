//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/17.
//

import SwiftUI

struct LaunchView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if colorScheme == .light {
                SwiftUIGIFPlayerView(gifName: "Launch01")
            } else {
                SwiftUIGIFPlayerView(gifName: "Launch02")
            }
        }
    }
}
