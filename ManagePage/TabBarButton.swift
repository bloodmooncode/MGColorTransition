
import SwiftUI

struct TabBarButton: View {
    var image: String
    var title: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = title
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: image)
                    .font(.system(size: getDevice() == .iPhone || getDevice() == .iPad ? 30 : 25))
                // For Dark Mode Adoption
                    .foregroundColor(selectedTab == title ? .white : .primary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    // For Dark Mode Adoption
                    .foregroundColor(selectedTab == title ? .white : .primary)
            }
            .padding(.bottom, 8)
            // Total Four Tabs
            .frame(width: self.getDevice() == .iPhone || getDevice() == .iPad ? (self.getScreen().width - 150) / 4 : 100, height: 55 + self.getSafeAreaBottom())
            .contentShape(Rectangle())
            // Bottom up Effect
            // if iPad or macOS moving effect will be from left
            .background(Color("purple").offset(x: selectedTab == title ? 0 : getDevice() == .iPhone || getDevice() == .iPad ? 0 : -100, y: selectedTab == title ? 0 : getDevice() == .iPhone || getDevice() == .iPad ? 100 : 0))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
