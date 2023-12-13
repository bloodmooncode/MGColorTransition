//
//  File.swift
//  MGColorTransition
//
//  Created by 张原溥 on 2022/4/19.
//

import SwiftUI
import AVFoundation
import AVKit
import Photos

struct CropVideoView: View {

    @State var progress : CGFloat = 0.0
//    @State var url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "example", ofType: "mp4") ?? "")

    @State var isPress = false
    @State var isShowingMediaPicker = false
    @State var selecturl : URL
    @State var urls: [URL] = []
    @State var isPreview = false
    @State var isSaveSuccess = false
    @State var isSaveFailed = false
    @State var selectSuccess = false
    
    private var selectButton: some View {
        
        Button(action: {
            selectSuccess = false
            isShowingMediaPicker = true
        }, label: {
            Text("Select Media")
                .fontWeight(.semibold)
        })
        .mediaImporter(isPresented: $isShowingMediaPicker,
                       allowedMediaTypes: .videos,
                       allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                self.urls = urls
                isPreview = true
                selecturl = urls[0]
                selectSuccess = true
            case .failure(let error):
                print(error)
                self.urls = []
                isPreview = false
                selecturl = URL(fileURLWithPath: Bundle.main.path(forResource: "example01", ofType: "mp4") ?? "")
            }
        }
    }

    var body: some View {
        VStack {
            HStack{
                selectButton
                Spacer()
                Button(action: {
                    squareCropVideo(inputURL: selecturl) { outputURL in
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL!)
                        }) { saved, error in
                            saved ? (isSaveSuccess = true) : (isSaveFailed = true)
                        }
                    }
                }, label: {
                    if selectSuccess{
                        Text("Export")
                            .fontWeight(.semibold)
                    }
                })
            }
            .frame(width: UIScreen.main.bounds.width - 100, height: 50)
            .padding()
            
            Spacer()
            
            PreviewPlayer(url: $selecturl, progress: $progress)
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
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height)
        .alert("Attention", isPresented: $isSaveSuccess, actions: {
            Button("I know", role: .cancel, action: {})

        }, message: {
            Text("The video has been cropped successfully")

        })
        .alert("Attention", isPresented: $isSaveFailed, actions: {
            Button("I know", role: .cancel, action: {})

        }, message: {
            Text("The crop process failed. Import and try it again")

        })
        
    }
    
    func squareCropVideo(inputURL: URL, completion: @escaping (_ outputURL : URL?) -> ()) {
        let videoAsset = AVAsset(url: inputURL)
        let clipVideoTrack = videoAsset.tracks(withMediaType: .video ).first! as AVAssetTrack
        
        let instruction = VideoHelper.videoCompositionInstruction(clipVideoTrack, asset: videoAsset)
        instruction.setOpacity(0.0, at: videoAsset.duration)

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: videoAsset.duration)
        mainInstruction.layerInstructions = [instruction]
        
        let videoComposition = AVMutableVideoComposition()
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        var finalTransform: CGAffineTransform = CGAffineTransform(translationX: 0, y: -clipVideoTrack.naturalSize.height / 2)
        
        finalTransform = finalTransform
            .translatedBy(x: 0, y: clipVideoTrack.naturalSize.height / 4.3)
        
        transformer.setTransform(finalTransform, at: .zero)
        mainInstruction.layerInstructions = [transformer]
        videoComposition.renderSize = CGSize(width: clipVideoTrack.naturalSize.width, height: clipVideoTrack.naturalSize.width * (9 / 16))
        
//        videoComposition.renderSize = CGSize(width: 1920, height: 1080)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.instructions = [mainInstruction]

        // Export
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!

        let path = NSTemporaryDirectory().appending("\(Date())crop.mp4")
        
        let outputFileURL = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: outputFileURL)
        
        exportSession.outputURL = outputFileURL
        exportSession.outputFileType = .mov
        exportSession.videoComposition = videoComposition

        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                print("Export completed\n")
                DispatchQueue.main.async(execute: {
                    completion(outputFileURL)
                })
                return
            } else if exportSession.status == .failed {
                print("Export failed - \(String(describing: exportSession.error!))\n")
            }

            completion(nil)
            return
        }
    }
}
