//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/14.
//

import SwiftUI
import AVFoundation
import Photos
import AVKit

struct VideoPicker: View {
    @State var urls: [URL] = []
    @State var isShowingMediaPicker = false
    @State var extract = false
    @State var regain = false
    @State var colorsMix : [Color] = []
    @Binding var selectedColor : Color
    @State var colorsMixClass : ColorsMixClass
    @State var next = false
    @Binding var selectedTab : String
    @State var ShowAlert = true
    @State var isDrug = false
    @State var ShowAlertExtract = false
    @State var ShowAlertNum = false
    @State var VideolessLength = false
    @State var VideoAspectWrong = false
    @State var VideoBothWrong = false
    @State private var WatchTutorial = false

    var selectButton: some View {
        
        Button(action: {
            isShowingMediaPicker = true
            extract = false
            next = false
            isDrug = false
            VideolessLength = false
            VideoAspectWrong = false
            VideoBothWrong = false
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
                if urls.count == 2 {
                    for url in urls {
                        let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first
                        let size = track!.naturalSize.applying(track!.preferredTransform)
                        if (abs(abs(size.width) / abs(size.height) - (16 / 9)) > 0.4) {
                            self.urls.removeAll()
                            VideoAspectWrong = true
                            VideolessLength = false
                        } else if AVAsset(url: url).duration.seconds < 10 {
                            self.urls.removeAll()
                            VideoAspectWrong = false
                            VideolessLength = true
                        }
                    }
                    ShowAlertNum = false
                }

            case .failure(let error):
                print(error)
                self.urls = []
            }
        }
    }
    
    var ExtractButton: some View {
        Button(action: {
            extract = true
            
        }, label: {
            Text("Extract")
                .fontWeight(.semibold)
        })
        .padding(.bottom,10)
    }
    
    var AlertButton: some View {
        Button (action: {
            ShowAlertExtract = true
        }, label: {
            Text("Extract")
                .fontWeight(.semibold)
                .opacity(0.7)
        })
        .padding(.bottom,10)
    }
    
    var NextButton: some View {
        Button(action: {
            next = true
            colorsMixClass.Colors = colorsMix
            selectedTab = "Generate MG"

        }, label: {
            Text("Next")
        })
        .padding(.bottom,10)
    }
    
    var RegainButton : some View {
        Button(action: {
            extract = false
            isDrug = true
            next = false
//            selectedTab = "Generate MG"
        }, label: {
            Text("Retrieve")
                .fontWeight(.semibold)
        })
        .padding(.bottom,10)
    }
    
    var body: some View {
        ZStack{
            
            ScrollView(showsIndicators: false) {
                Section {
                    if urls.count == 2 {
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
        //                        VideoPlayer(player: AVPlayer(url: url))
                                
                                VideoCut(url: url, extract: $extract, colorsMix: $colorsMix, isDrug: $isDrug)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                                
                                
                            default:
                                Text("Can't display \(url.lastPathComponent)")
                            }
                        }
                        .onAppear{
                            ShowAlertNum = false
                        }
                    } else if (urls.count == 1 || urls.count > 2) {
                        Text("")
                            .onAppear{
                                ShowAlertNum = true
                            }
                    }
                    
                } header: {
                    HStack{
                        selectButton
                        Spacer()
                        Button(action: {
                            self.WatchTutorial.toggle()
                        }, label: {
                            Text("Watch the video tutorial")
                                .fontWeight(.semibold)
                        })
                        
                        Spacer()
                        if isDrug {
                            if !extract && !next {
                                ExtractButton
                            } else if extract && !next {
                                NextButton
                            } else {
                                RegainButton
                            }
                        } else {
                            AlertButton
                                .alert("Attention", isPresented: $ShowAlertExtract, actions: {
                                    Button("I know", role: .cancel, action: {
                                        ShowAlertExtract = false
                                    })

                                }, message: {
                                    Text("Please drag the both progress bars")
                                })
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .padding()
                    .padding(.top, 10)
                }
                Spacer()
            }
            
            Text("Only 2 videos are allowed.")
                .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                .padding()
                .background(Color("Background").opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color("Background"), lineWidth: 2)
                )
                .opacity(ShowAlertNum ? 1 : 0)
            
            Text("Only the videos longer than 10s allowed.")
                .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                .padding()
                .background(Color("Background").opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color("Background"), lineWidth: 2)
                )
                .opacity(VideolessLength ? 1 : 0)
            
            Text("Only videos with a 16:9 aspect ratio are allowed. If you have no videos conforming, please go to the crop video tab to make one.")
                .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                .padding()
                .background(Color("Background").opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color("Background"), lineWidth: 2)
                )
                .opacity(VideoAspectWrong ? 1 : 0)
            
            if WatchTutorial{
                VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: "teach01", withExtension: "mp4")!))
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
        .alert("Attention", isPresented: $ShowAlert, actions: {
            
            Button("I know", role: .cancel, action: {})

        }, message: {
            Text("The 2 videos chosen should not less than 10s and the length to width ratio should be 16:9")
        })
    }
    
    func videoDuration(videoAsset: PHAsset?) -> Int {
        guard let asset = videoAsset else { return 0 }
        let duration: TimeInterval = asset.duration
        let length = Int(duration)
        return length
    }
    
    func getURL(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
            
        if mPhasset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL)
            })
        } else if mPhasset.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
