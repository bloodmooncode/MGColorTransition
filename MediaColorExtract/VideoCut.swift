//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/14.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoCut: View {

    @State var currentCoverImage: UIImage?
    @State var progress: CGFloat = 0
//    @State var url = URL(fileURLWithPath: Bundle.main.path(forResource: "Life", ofType: "mp4") ?? "")
    @State var url: URL
    @Binding var extract: Bool
    @State var selectedColor : Color = .clear
    @Binding var colorsMix: [Color]
    @State var isClear = false
    @Binding var isDrug : Bool
    
    var body: some View {
        
        VStack {

            if extract  {
                VideoCoverImage(currentCoverImage: $currentCoverImage, extract: $extract, selectedColor: $selectedColor, colorsMix: $colorsMix,isClear: $isClear)
            }
            
            else {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {

                        PreviewPlayer(url: $url, progress: $progress)
                            .cornerRadius(10)
                            .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.primary,lineWidth: 3))
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
                    .frame(width: size.width, height: size.height)
                }
                .frame(width: UIScreen.main.bounds.width - 100)
                
                Text("Drag the progress bar to select a keyframe")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                // Cover Image
                let size = CGSize(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height / 3)
                VideoCoverScroller(videoURL: $url, progress: $progress,imageSize: size, coverImage: $currentCoverImage, extract: $extract, isDrug: $isDrug)
                    .padding(.top,50)
                    .padding(.horizontal,50)
            
                Spacer()
            }
        }
    }
}

struct PreviewPlayer: UIViewControllerRepresentable {
    
    @Binding var url : URL
    @Binding var progress : CGFloat
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
//        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        let playURL = (uiViewController.player?.currentItem?.asset as? AVURLAsset)?.url
        if let playerURL = playURL,playerURL != url {
//            print("Updated")
            uiViewController.player = AVPlayer(url: url)
        }
        
        let duration = uiViewController.player?.currentItem?.duration.seconds ?? 0
        let time = CMTime(seconds: progress * duration, preferredTimescale: 600)
        uiViewController.player?.seek(to: time)
    }
}

struct VideoCoverScroller : View {
    @Binding var videoURL : URL
    @Binding var progress : CGFloat
    @State var imageSequence: [UIImage]?
    
    @State var offset:CGFloat = 0
    @GestureState var isDragging: Bool = false
    var imageSize: CGSize
    @Binding var coverImage :UIImage?
    @Binding var extract: Bool
    @Binding var isDrug : Bool
    
    var body: some View {

        GeometryReader {proxy in
            let size = proxy.size
            
             HStack(spacing: 0) {
                if let imageSequence = imageSequence {
                    ForEach(imageSequence,id: \.self) { index in
                        GeometryReader{ proxy in
                            let subSize = proxy.size
                            
                            Image(uiImage: index)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: subSize.width, height: subSize.height)
                            
                        }
                        .frame(height: size.height)
                    }
                }
            }
            .cornerRadius(10)
            .overlay(alignment: .leading, content: {
                ZStack(alignment: .leading) {
                    Color.primary
                        .opacity(0.25)
                        .frame(height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    PreviewPlayer(url: $videoURL, progress: $progress)
                        .frame(width: 65, height: 90)
                        .cornerRadius(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.primary,lineWidth: 2)
                                .padding(-3)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.black.opacity(0.2))
                                .padding(-4)
                        )
                        .offset(x:offset)
                        .onAppear{
                            do{
                                 let audioSession = AVAudioSession.sharedInstance()
                                try audioSession.setCategory(AVAudioSession.Category.playback)
                               }
                                 catch let error as NSError {
                                 print("Could not create audio player: \(error)")
                             }
                        }
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({value in
                                    var translation = (isDragging ? value.location.x - 35 : 0)
                                    translation = (translation < 0 ? 0 : translation)
                                    translation = (translation > size.width - 70 ? size.width - 70 : translation)
                                    
                                    if translation != 0 {
                                        isDrug = true
                                    }
                                    offset = translation
                                    
                                    self.progress = (translation / (size.width - 70))
                                })
                                .onEnded({ _ in
                                    retrieveCoverImageAt(progress: progress, size: imageSize) { image in
                                        self.coverImage = image
                                    }
                                })
                        )
                }
            })
            .onAppear {
                generateImageSequence()
            }
            .onChange(of: videoURL) {_ in
                progress = 0
                offset = .zero
                coverImage = nil
                imageSequence = nil
                
                generateImageSequence()
                retrieveCoverImageAt(progress: progress, size: imageSize) {
                    image in
                    self.coverImage = image
                }
            }
        }
        .frame(height: 80)
    }
    
    func generateImageSequence() {
        let parts = (videoDuration() / 20)
        
        (0..<20).forEach { index in
            let progress = (CGFloat(index) * parts) / videoDuration()
            
            retrieveCoverImageAt(progress: progress, size: CGSize(width: 100, height: 100)) { image in
                if imageSequence == nil { imageSequence = [] }
                imageSequence?.append(image)
            }
        }
    }
    
    func retrieveCoverImageAt(progress:CGFloat,size:CGSize,completion:@escaping (UIImage)->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            let asset = AVAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = size
            
            let time = CMTime(seconds: progress * videoDuration(), preferredTimescale: 600 )
            
            do {
                let image = try generator.copyCGImage(at: time, actualTime: nil)
                let cover = UIImage(cgImage: image)
                DispatchQueue.main.async {
                    completion(cover)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func videoDuration() -> Double{
        let asset = AVAsset(url: videoURL)
        return asset.duration.seconds
    }
}
