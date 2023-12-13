//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/16.
//

import SwiftUI
import AVKit

struct VideoMerge: View {
    @State var urls: [URL] = []
    @State var isShowingMediaPicker = false
    @State var assets : [AVAsset] = []
    @State var progress: CGFloat = 0
    @State var url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "example02", ofType: "mp4") ?? "")
    @State var isMerging = false
    @State var isPress = false
    @State var isImport = false
    @State var ShowMergeSuccess = false
    @State var ShowMergeFail = false
    @State var MergedSuccess = false
    
    @Environment(\.colorScheme) var colorScheme
    
    private var selectButton: some View {
        
        Button(action: {
            isShowingMediaPicker = true
            ShowMergeSuccess = false
            isMerging = false
            MergedSuccess = false
            urls = []
            assets = []
            isImport = false
        }, label: {
            Text("Select Media")
                .fontWeight(.semibold)
        })
        .mediaImporter(isPresented: $isShowingMediaPicker,
                       allowedMediaTypes: .videos,
                       allowsMultipleSelection: true) { result in
            switch result {
            case .success(let urls):
                self.urls = urls
//                print("222222\(urls.description)")
                isImport = true

            case .failure(let error):
                print(error)
                self.urls = []
            }
        }
       .onTapGesture {
           for url in urls {
               assets.append(AVAsset(url: url))
           }
       }
    }
    
    var FinalButton: some View {
        
        Button(action: {
//            MergeSuccess = false
            if isImport {
                isMerging = true
                KVVideoManager.shared.merge(arrayVideos: assets) { (outputURL, error) in
                      if let error = error {
                           print("Error:\(error.localizedDescription)")
                          ShowMergeFail = true
                      }
                      else {
                           if let url = outputURL {
    //                           print("Output video file:\(url)")
                               self.url = url
                               ShowMergeSuccess = true
                               MergedSuccess = true
                           }
                     }
                }
            }
            
        }, label: {
            Text("Merge")
                .fontWeight(.semibold)
        })
    }
    
    var DownloadButton: some View {
        Image (systemName: "tray.and.arrow.down")
            .foregroundColor(Color("AccentColor"))
            .onTapGesture {
                if MergedSuccess {
                    isPress = true
                }
            }
            .shareSheet(show: $isPress, items:[url])
    }

    var body: some View {
        
        ZStack {
            VStack {
                Section {
                    ForEach(urls, id: \.absoluteString) { url in
                        switch try! url.resourceValues(forKeys: [.contentTypeKey]).contentType! {
                        case let contentType where contentType.conforms(to: .image):
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        case let contentType where contentType.conforms(to: .audiovisualContent):
//                            VideoPlayer(player: AVPlayer(url: url))
                                Text("")
                                .onAppear{
                                    assets.append(AVAsset(url: url))
                                }

                        default:
                            Text("Can't display \(url.lastPathComponent)")
                        }
                    }
                } header: {
                    HStack(spacing: 20){
                        selectButton
                        Spacer()
                        Text("Please Add the Video Queue")
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                        FinalButton.opacity(isImport ? 1 : 0.5)
                        
                        DownloadButton.opacity(MergedSuccess ? 1 : 0.5)
                    }
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .padding()
                }
                
                Spacer()
                ZStack{
                    VStack(alignment: .center){
                        PreviewPlayer(url: $url, progress: $progress)
                            .frame(width: UIScreen.main.bounds.width - 100, height: (UIScreen.main.bounds.width - 100) * (9 / 16))
                            .cornerRadius(10)
                        
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.primary, lineWidth: 3)
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
                    if isMerging && !ShowMergeFail && !ShowMergeSuccess {
                        LoadView()
                            .frame(width: UIScreen.main.bounds.width - 200, height: (UIScreen.main.bounds.width - 200) * (4 / 3))
                            .cornerRadius(30)
                            .shadow(color: .primary.opacity(0.2), radius: 5, x: 2, y: 2)
                    }
                }
                Spacer()
            }
        }
        .alert("Attention", isPresented: $ShowMergeSuccess, actions: {
               Button("I know", role: .cancel, action: { isMerging = false })

            }, message: {
               Text("The videos have been merged successfully, click the export icon to save it.")

        })
        .alert("Attention", isPresented: $ShowMergeFail, actions: {
               Button("I know", role: .cancel, action: { isMerging = false })

           }, message: {
               Text("The merge process failed. Import and try it again")

        })
    }
}
