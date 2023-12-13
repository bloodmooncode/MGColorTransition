//
//  InsideTabBarItems.swift
//  SharedTabBar (iOS)
//
//  Created by Ginger on 17/02/2021.
//

import SwiftUI

struct InsideTabBarItems: View {
    @Binding var selectedTab : String
    
    var body: some View {
        Group {
            
            TabBarButton(image: "house", title: "Home Page", selectedTab: $selectedTab)
            TabBarButton(image: "photo.on.rectangle.angled", title: "Pick Media", selectedTab: $selectedTab)
            TabBarButton(image: "square.stack.3d.forward.dottedline", title: "Generate MG", selectedTab: $selectedTab)
            TabBarButton(image: "crop", title: "Crop Video", selectedTab: $selectedTab)
            TabBarButton(image: "command", title: "Merge Video", selectedTab: $selectedTab)
        }
        .background(Color("TabBackground").opacity(0.6))
    }
}
