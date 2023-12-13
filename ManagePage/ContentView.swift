
import SwiftUI

struct ContentView: View {
    @State var colorsMix : [Color] = []
    @State var selectedColor : Color = .clear
    @State var colorsMixClass = ColorsMixClass()
    @State private var showingSheet = true
    @State var isLand = false
    @State var selecturl = URL(fileURLWithPath: Bundle.main.path(forResource: "example01", ofType: "mp4") ?? "")
    
    let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    
    var body: some View {
        VStack {
            
            if isLand {
                Text("Please rotate your iPad to portrait mode in order to have a better experience.")
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            } else {
                MainView()
                    .sheet(isPresented: $showingSheet) {
                        LaunchView()
                    }
            }
//            MediaConverter(selecturl: selecturl)
        }
        .onReceive(orientationPublisher) { _ in
            let windowScene = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first?.windowScene
            self.isLand = windowScene?.interfaceOrientation.isLandscape ?? false
        }
        
    }
}
