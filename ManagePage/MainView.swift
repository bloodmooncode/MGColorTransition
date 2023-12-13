//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/13.
//

import SwiftUI

struct MainView: View {
    // Hiding TabBar
    init() {
        // UITabBar is not available for macOS
        #if os(iOS)
        UITabBar.appearance().isHidden = true
        #endif
    }
        
    // SelectedTab
    @State var selectedTab = "Home Page"
    @State var colorsMix : [Color] = []
    @State var selectedColor : Color = .clear
    @State var colorsMixClass = ColorsMixClass()
    @State var selecturl = URL(fileURLWithPath: Bundle.main.path(forResource: "example01", ofType: "mp4") ?? "")
    
    // For Dark Mode
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack(alignment: getDevice() == .iPhone || getDevice() == .iPad ? .bottom : .leading) {
            // Since TabBar hide option is not available so we can't use native TabBar in macOS
            #if os(iOS)
            TabView(selection: $selectedTab) {
                HomePage()
                    .tag("Home Page")
                    .ignoresSafeArea(.all, edges: .all)
                VideoPicker(colorsMix: colorsMix, selectedColor: $selectedColor, colorsMixClass: colorsMixClass,selectedTab: $selectedTab)
                    .tag("Pick Media")
                    .ignoresSafeArea(.all, edges: .all)
                
                TransitionAnimate(colorsMixclass: colorsMixClass,selectedTab:$selectedTab)
                    .tag("Generate MG")
                    .ignoresSafeArea(.all, edges: .all)
                
                CropVideoView(selecturl: selecturl)
                    .tag("Crop Video")
                    .ignoresSafeArea(.all, edges: .all)
                
                VideoMerge()
                    .tag("Merge Video")
                    .ignoresSafeArea(.all, edges: .all)
                
                
            }
            #else
            ZStack {
                // Switch case for Changing Views
                switch(selectedTab) {
                case "SwiftUI": Color.red
                case "Beginners": Color.blue
                case "macOS": Color.yellow
                case "Contact": Color.pink
                default: Color.clear
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            #endif
            
            if self.getDevice() == .macOS {
                
                VStack(spacing: 10) {
                    InsideTabBarItems(selectedTab: $selectedTab)
                    
                    Spacer()
                }
                .background(scheme == .dark ? Color.black : Color.white)
            } else {
                // Custom TabBar
                HStack(spacing: 0) {
                    InsideTabBarItems(selectedTab: $selectedTab)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(scheme == .dark ? Color.black : Color.white)
            }
        }
        .ignoresSafeArea(.all, edges: getDevice() == .iPhone || getDevice() == .iPad ? .bottom : .all)
        .frame(width: getDevice() == .iPad || getDevice() == .iPhone || getDevice() == .iPad ? nil : getScreen().width / 1.6, height: getDevice() == .iPad || getDevice() == .iPhone ? nil : getScreen().height - 150)
    }
}

extension View {
    func getScreen() -> CGRect {
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main!.visibleFrame
        #endif
    }
    
    // Safe Area Bottom
    func getSafeAreaBottom() -> CGFloat {
        #if os(iOS)
        return UIApplication.shared.connectedScenes
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows.first?.safeAreaInsets.bottom ?? 10
        #else
        return 10
        #endif
    }
    
    // Getting Device Type
    func getDevice() -> Device {
        #if os(iOS)
        
        // Since there is no direct for Getting iPadOS
        // Alternative way
        if UIDevice.current.model.contains("iPad") {
            return .iPad
        } else {
            return .iPhone
        }
        #else
        return .macOS
        #endif
    }
}

enum Device {
    case iPhone
    case iPad
    case macOS
}



