//
//  VideoPlayerView.swift
//  themoviedb
//
//  Created by Farid Afzal on 22/11/2023.
//

import SwiftUI

import AVKit

struct VideoPlayerView: View {
    
    @State var player = AVPlayer(url: URL(string: Constants.videoURL.url)!)
    @State var isplaying = false
    @State var showcontrols = false
    @State var value : Float = 0
    @State private var isBuffering = false
    
    var body: some View {
        
        VStack{
            
            ZStack{

                VideoPlayer(player: $player)
   
                //ActivityIndicatorView()
                
                if self.showcontrols{
                    
                    VideoControlsView(player: self.$player, isplaying: self.$isplaying, pannel: self.$showcontrols,value: self.$value)
                    
                    
                    //.background(Color.gray)
                }
                
            }
            .frame(height: UIScreen.main.bounds.height / 3.5)
            
            .onTapGesture {
                
                self.showcontrols = true
            }
            
        }
        .frame(height: UIScreen.main.bounds.size.height)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            self.player.play()
            self.isplaying = true
        }
        .onDisappear {
            self.player.pause()
            self.isplaying = false
        }
    }
    // Observe changes to the player's timeControlStatus
    func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            if let player = object as? AVPlayer {
                switch player.timeControlStatus {
                case .playing:
                    isBuffering = false
                case .paused, .waitingToPlayAtSpecifiedRate:
                    isBuffering = true
                @unknown default:
                    break
                }
            }
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
// Observe changes to the player's timeControlStatus
struct VideoControlsView : View {
    
    @Binding var player : AVPlayer
    @Binding var isplaying : Bool
    @Binding var pannel : Bool
    @Binding var value : Float
    
    var body : some View{
        
        VStack{
            
            Spacer()
            
            HStack{
                
                Button(action: {
                    
                    self.player.seek(to: CMTime(seconds: self.getSeconds() - 10, preferredTimescale: 1))
                    
                }) {
                    
                    Image(systemName: Constants.ImageConstants.goBack10Sec)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    
                    if self.isplaying{
                        
                        self.player.pause()
                        self.isplaying = false
                    }
                    else{
                        
                        self.player.play()
                        self.isplaying = true
                    }
                    
                }) {
                    
                    Image(systemName: self.isplaying ? Constants.ImageConstants.pauseFill : Constants.ImageConstants.playFill)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    
                    self.player.seek(to: CMTime(seconds: self.getSeconds() + 10, preferredTimescale: 1))
                    
                }) {
                    
                    Image(systemName: Constants.ImageConstants.goForward10Sec)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
            }
            
            Spacer()
            
            CustomProgressBar(value: self.$value, player: self.$player, isplaying: self.$isplaying)
            
        }.padding()
        .background(Color.black.opacity(0.4))
        .onTapGesture {
                
            self.pannel = false
        }
        .onAppear {
            
            self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (_) in
                
                self.value = self.getSliderValue()
                
                if self.value == 1.0{
                    
                    self.isplaying = false
                }
            }
        }
        
        
    }
    
    func getSliderValue()->Float{
        
        return Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds)!)
    }
    
    func getSeconds()->Double{
        
        return Double(Double(self.value) * (self.player.currentItem?.duration.seconds)!)
    }
}

struct CustomProgressBar : UIViewRepresentable {
    
    
    func makeCoordinator() -> CustomProgressBar.Coordinator {
        
        return CustomProgressBar.Coordinator(parent1: self)
    }
    
    
    @Binding var value : Float
    @Binding var player : AVPlayer
    @Binding var isplaying : Bool
    
    func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
     
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .gray
        slider.thumbTintColor = .red
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.value = value
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBar>) {
        
        uiView.value = value
    }
    
    class Coordinator : NSObject{
        
        var parent : CustomProgressBar
        
        init(parent1 : CustomProgressBar) {
            
            parent = parent1
        }
        
        @objc func changed(slider : UISlider){
            
            if slider.isTracking{
                
                parent.player.pause()
                
                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
                
                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
            }
            else{
                
                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
                  
                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
                
                if parent.isplaying{
                    
                    parent.player.play()
                }
            }
        }
    }
}

class Host : UIHostingController<VideoPlayerView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}

struct VideoPlayer : UIViewControllerRepresentable {
    
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        
        
    }
}

#Preview {
    VideoPlayerView()
}
