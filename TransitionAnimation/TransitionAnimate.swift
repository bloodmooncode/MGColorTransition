//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/15.
//

import SwiftUI
import AVKit
 
class ColorsMixClass: ObservableObject {
    @Published var Colors : [Color] = []
}

struct TransitionAnimate: View {
    @ObservedObject var colorsMixclass = ColorsMixClass()
    @State var index: Int = 0
    @State var progress: CGFloat = 0
    @State var Transitioncolors :String = ""
    @State var RGBColors : [Color] = []
    @State var showButton = true
    
    @State var Animation01 = false
    @State var Animation02 = false
    @State var Animation03 = false
    @State var Animation04 = false
    @State var Animation05 = false
    @State var Animation06 = false
    
    @State var isRecording : Bool = false
    @State var url : URL?
    @State var shardVideo: Bool = false
    @State var TapNum : Int = 0
    
    @State var isActiveted = false
    @State var ShowAlertActivate = false
    @Binding var selectedTab : String
    @State var isClear = true
    @State var isChangeButtonState = true
    
    @State private var animationAmount = 1.0
    @State var showRemind = false
    @State var num01 : Int = 0
    @State private var WatchTutorial = false
    
    let columns = [GridItem(.adaptive(minimum: 6))]
    
    var ClearEffect: some View {
        Button (action: {
            Animation01 = false
            Animation02 = false
            Animation03 = false
            Animation04 = false
            Animation05 = false
            Animation06 = false
//            RGBColors = []
            colorsMixclass.Colors = []
            isActiveted = false
            ShowAlertActivate = false
        }, label: {
            
            HStack(spacing: 10){
                Text("Clear the screen")
                    .fontWeight(.semibold)
                Image(systemName: "exclamationmark.bubble")
                    .onTapGesture {
                        self.isClear.toggle()
                    }
            }
        })
    }
    
    var ExchangeButton : some View {
        Button (action: {
            self.showButton.toggle()
        }, label: {
            HStack (spacing: 10){
                Text(showButton ? "HideButton" : "ShowButton" )
                    .fontWeight(.semibold)
                Image(systemName: "exclamationmark.bubble")
                    .onTapGesture {
                        self.isChangeButtonState.toggle()
                    }
            }
        })
    }
    
    var body: some View {
        ZStack {
            
            if colorsMixclass.Colors.count == 2 {
            
                let rgbcolor01 = ConvertColor(hexColor: colorsMixclass.Colors[0].hex ?? "")
                let rgbcolor02 = ConvertColor(hexColor: colorsMixclass.Colors[1].hex ?? "")
                
                let Color01 = Color(red: rgbcolor01[0], green: rgbcolor01[1], blue: rgbcolor01[2])
                let Color02 = Color(red: (rgbcolor01[0] + rgbcolor02[0]) * 0.5, green: (rgbcolor01[1] + rgbcolor02[1]) * 0.5, blue: (rgbcolor01[2] + rgbcolor02[2]) * 0.5)
                let Color03 = Color(red: rgbcolor02[0], green: rgbcolor02[1], blue: rgbcolor02[2])
                
                
                VStack (spacing: 20) {

                    HStack(spacing: 20 ) {
                        
                        Color03
                            .frame(width: 70, height: 70)
                            .cornerRadius(35)
                            .overlay(Circle().stroke(Color.primary,lineWidth: 1.5))
                            .shadow(color: Color.primary.opacity(0.2), radius: 3, x: 0, y: 3)
                        Color02
                            .frame(width: 70, height: 70)
                            .cornerRadius(35)
                            .overlay(Circle().stroke(Color.primary,lineWidth: 1.5))
                            .shadow(color: Color.primary.opacity(0.2), radius: 3, x: 0, y: 3)
                        Color01
                            .frame(width: 70, height: 70)
                            .cornerRadius(35)
                            .overlay(Circle().stroke(Color.primary,lineWidth: 1.5))
                            .shadow(color: Color.primary.opacity(0.2), radius: 3, x: 0, y: 3)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 200, height: 100)
                    .offset(y: !isActiveted ? 0 : -UIScreen.main.bounds.height / 3)

                Button (action: {
                    RGBColors = [Color03,Color02,Color01]
                    isActiveted = true
                    
                }, label: {
                        Text("Activate the effects")
                            .foregroundColor(Color.primary)
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width / 2.5)
                            .multilineTextAlignment(.center)
                            .opacity(isActiveted ? 0 : 1)

                    })
                }
                .frame(height: UIScreen.main.bounds.height - 200)
                
                
            } else {
                
                VStack{
                    Spacer()
                    Text("There haven't been any color collect, you can choose different effects and tap blank space on the screen to experience the preview.")
                        .foregroundColor(Color.primary)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .multilineTextAlignment(.center)
                        .opacity(showButton ? 1 : 0)
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                .onAppear{
                    RGBColors = [.blue, .purple, .pink]
                }
            }
            
            VStack {
                if isActiveted || colorsMixclass.Colors.count == 0 {
                    Text("")
                        .onAppear{
                            showButton = true
                        }
                    ZStack{
                        if Animation01 {
                            SplashView(animationType: .angle(Angle(degrees: 45)), color: RGBColors[self.index])
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .edgesIgnoringSafeArea(.all)
                                .onAppear {
                                    num01 = num01 + 1
                                }
                                .onTapGesture {
                                    
                                    TapNum = TapNum + 1
                                    
                                    if (TapNum % 2 == 0) {
                                        self.index = (self.index - 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index - 1) % RGBColors.count
                                        }
                                    } else {
                                        self.index = (self.index + 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index + 1) % RGBColors.count
                                        }
                                    }
                                }
                            if num01 == 1{
                                Text("")
                                    .alert("Remind", isPresented: $showRemind, actions: {
                                        Button("I know", role: .cancel, action: {}
                                        )}, message: {
                                            Text("You can touch the screen to preview the effects and Use the button in the lower right corner to record it. If you want to exchange the effects, you can click the upper right button to choose another. ")
                                        })
                                                 
                            }
                        }
                        
                        if Animation02 {
                            SplashView(animationType: .angle(Angle(degrees: 135)), color: RGBColors[self.index])
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    
                                    TapNum = TapNum + 1
                                    
                                    if (TapNum % 2 == 0) {
                                        self.index = (self.index - 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index - 1) % RGBColors.count
                                        }
                                    } else {
                                        self.index = (self.index + 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index + 1) % RGBColors.count
                                        }
                                    }
                                }
                        }
                        
                        if Animation03 {
                            SplashView(animationType: .angle(Angle(degrees: 120)), color: RGBColors[self.index])
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    
                                    TapNum = TapNum + 1
                                    
                                    if (TapNum % 2 == 0) {
                                        self.index = (self.index - 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index - 1) % RGBColors.count
                                        }
                                    } else {
                                        self.index = (self.index + 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index + 1) % RGBColors.count
                                        }
                                    }
                                }
                        }
                        
                        if Animation04 {
                            SplashView(animationType: .angle(Angle(degrees: 180)), color: RGBColors[self.index])
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    
                                    TapNum = TapNum + 1
                                    
                                    if (TapNum % 2 == 0) {
                                        self.index = (self.index - 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index - 1) % RGBColors.count
                                        }
                                    } else {
                                        self.index = (self.index + 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index + 1) % RGBColors.count
                                        }
                                    }
                                }
                        }
                        
                        if Animation05 {
                            SplashView(animationType: .topToBottom, color: RGBColors[self.index])
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    
                                    TapNum = TapNum + 1
                                    
                                    if (TapNum % 2 == 0) {
                                        self.index = (self.index - 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index - 1) % RGBColors.count
                                        }
                                    } else {
                                        self.index = (self.index + 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index + 1) % RGBColors.count
                                        }
                                    }
                                }
                        }
                        
                        if Animation06 {
                            SplashView(animationType: .circle, color: RGBColors[self.index])
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    
                                    TapNum = TapNum + 1
                                    
                                    if (TapNum % 2 == 0) {
                                        self.index = (self.index - 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index - 1) % RGBColors.count
                                        }
                                    } else {
                                        self.index = (self.index + 1) % RGBColors.count
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.index = (self.index + 1) % RGBColors.count
                                        }
                                    }
                                }
                        }
     
                        
                        VStack (alignment: .center, spacing: 20) {
                        HStack(alignment: .center, spacing: 20) {
                            Button(action: {
                                Animation01 = true
                                Animation02 = false
                                Animation03 = false
                                Animation04 = false
                                Animation05 = false
                                Animation06 = false
                                self.index = 0
                                TapNum = 0
                                showRemind = true
                            }, label: {
                                Text("Effect01")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: 100, height: 100)
                            .background(Color("purple").opacity(0.6))
                            .cornerRadius(10)
                            
                            Button(action: {
                                Animation01 = false
                                Animation02 = true
                                Animation03 = false
                                Animation04 = false
                                Animation05 = false
                                Animation06 = false
                                self.index = 0
                                TapNum = 0
                                showRemind = true
                            }, label: {
                                Text("Effect02")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: 100, height: 100)
                            .background(Color("purple").opacity(0.6))
                            .cornerRadius(10)
                            
                            Button(action: {
                                Animation01 = false
                                Animation02 = false
                                Animation03 = true
                                Animation04 = false
                                Animation05 = false
                                Animation06 = false
                                TapNum = 0
                                self.index = 0
                                showRemind = true
                            }, label: {
                                Text("Effect03")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: 100, height: 100)
                            .background(Color("purple").opacity(0.6))
                            .cornerRadius(10)
                        }
                        
                        HStack(alignment: .center, spacing: 20) {
                            Button(action: {
                                Animation01 = false
                                Animation02 = false
                                Animation03 = false
                                Animation04 = true
                                Animation05 = false
                                Animation06 = false
                                TapNum = 0
                                self.index = 0
                                showRemind = true
                            }, label: {
                                Text("Effect04")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: 100, height: 100)
                            .background(Color("purple").opacity(0.6))
                            .cornerRadius(10)
                            
                            
                            Button(action: {
                                Animation01 = false
                                Animation02 = false
                                Animation03 = false
                                Animation04 = false
                                Animation05 = true
                                Animation06 = false
                                TapNum = 0
                                self.index = 0
                                showRemind = true
                            }, label: {
                                Text("Effect05")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: 100, height: 100)
                            .background(Color("purple").opacity(0.6))
                            .cornerRadius(10)
                            
                            Button(action: {
                                Animation01 = false
                                Animation02 = false
                                Animation03 = false
                                Animation04 = false
                                Animation05 = false
                                Animation06 = true
                                TapNum = 0
                                self.index = 0
                                showRemind = true
                            }, label: {
                                Text("Effect06")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: 100, height: 100)
                            .background(Color("purple").opacity(0.6))
                            .cornerRadius(10)
                        }
                    }
                        .opacity(showButton ? 1 : 0.01)
                    

                        VStack{
                            Spacer()
        
                            HStack{
                                Spacer()
                                Button {
                                    
                                } label : {
                                    Image (systemName: isRecording ? "record.circle.fill" : "record.circle")
                                        .font(.largeTitle)
                                        .foregroundColor(isRecording ? .red : .white)
                                        .onTapGesture {
                                            
                                            TapNum = TapNum + 1
                                            
                                            if (TapNum % 2 == 0) {
                                                self.index = (self.index - 1) % RGBColors.count
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    self.index = (self.index - 1) % RGBColors.count
                                                }
                                            } else {
                                                self.index = (self.index + 1) % RGBColors.count
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    self.index = (self.index + 1) % RGBColors.count
                                                }
                                            }
                                            
                                            if isRecording {
                                                Task{
                                                    do {
                                                        self.url = try await stopRecording()
                                                        isRecording = false
                                                        shardVideo.toggle()
                                                    } catch {
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                            } else {
                                                startRecording { error in
                                                    if let error = error {
                                                        print(error.localizedDescription)
                                                        return
                                                    }
                                                    isRecording = true
                                                }
                                            }
                                        }
                                }
                                .padding()
                                .shareSheet(show: $shardVideo, items: [url])
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 200)
                    }
                    
                } else if colorsMixclass.Colors.count == 2 {
                    
                    Text("")
                        .onAppear{
                            ShowAlertActivate = true
                        }
                        .alert("Attention", isPresented: $ShowAlertActivate, actions: {
                                    
                                    Button("I know", role: .cancel, action: {})

                                }, message: {
                                    Text("You haven't activate animation effects, please click the Activation button below")
                                })
                    
                } else {
                    Text("")
                        .alert("Attention", isPresented: $ShowAlertActivate, actions: {
                                    
                                    Button("I know", role: .cancel, action: {})

                                }, message: {
                                    Text("Maybe you have some wrong operations, back to watch the tutorial")

                                })
                }
                Spacer()
            }
            VStack{
                HStack {
                    VStack (alignment: .leading, spacing: 10){
                        ClearEffect
                            
                        
                        Text("The clear button is used to delete any colors, animations and effects")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color("Background").opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color("Background"), lineWidth: 2)
                            )
                            .opacity(isClear ? 1 : 0.01)
//                            .animation(.easeInOut)
                            .animation(
                                .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: animationAmount
                            )
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    isClear = false
                                }
                            }
                    }
                    .opacity(isActiveted ? 0 : 1)
                    
                    Spacer()

                    
                    Button(action: {
                        self.WatchTutorial.toggle()
                    }, label: {
                        Text("Watch tutorial")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    })
                    .offset(y: -50)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10){
                        ExchangeButton
                        
                        Text("The button is used to show/hide the buttons and texts on the screen in order to record.")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color("Background").opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color("Background"), lineWidth: 2)
                            )
                            .opacity(isChangeButtonState ? 1 : 0.01)
                            .animation(
                                .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: animationAmount
                            )
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    isChangeButtonState = false
                                }
                            }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width - 100, height: 200)
                .padding()
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            
            if WatchTutorial{
                VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: "teach02", withExtension: "mp4")!))
                    .frame(width: UIScreen.main.bounds.width - 200, height:(UIScreen.main.bounds.width - 200) * (4 / 3))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.primary, lineWidth: 2)
                    )
                    .onAppear{
                        do{
                             let audioSession = AVAudioSession.sharedInstance()
                            try audioSession.setCategory(AVAudioSession.Category.playback)
                           }
                             catch let error as NSError {
                             print("Could not create audio player: \(error)")
                         }
                    }
            }
            
        }
        .onDisappear{
            Animation01 = false
            Animation02 = false
            Animation03 = false
            Animation04 = false
            Animation05 = false
            Animation06 = false
            colorsMixclass.Colors = []
            isActiveted = false
            ShowAlertActivate = false
        }
    }
    
    func ConvertColor(hexColor: String) -> [CGFloat] {
        var r, g, b, a: CGFloat
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                return [r,g,b,a]
            }
        }
        return []
    }
    
}
