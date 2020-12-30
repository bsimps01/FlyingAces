//
//  BackgroundMusicMenu.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 12/3/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation
import AVFoundation

class MyAudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    private static let sharedPlayer: MyAudioPlayer = {
        return MyAudioPlayer()
    }()
    

    private var container = [String : AVAudioPlayer]()

    static func playFile(name: String, type: String) {
        var player: AVAudioPlayer?
        let key = name + type
        for (file, thePlayer) in sharedPlayer.container {
            if file == key {
                player = thePlayer
                break
            }
        }
        if player == nil, let resource = Bundle.main.path(forResource: name, ofType:type) {
            do {
                player = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: resource) as URL, fileTypeHint: AVFileType.mp3.rawValue)
            } catch {
                // error
            }
        }
        if let thePlayer = player {
            if thePlayer.isPlaying {
                // already playing
            } else{
                thePlayer.delegate = sharedPlayer
                sharedPlayer.container[key] = thePlayer
                thePlayer.numberOfLoops = -1
                thePlayer.play()
            }
        }
    }
    
    static func stopFile(name: String, type: String){
        var player: AVAudioPlayer?
        let key = name + type
        for (file, thePlayer) in sharedPlayer.container {
            if file == key {
                player = thePlayer
                break
            }
        }
        if let thePlayer = player {
            if thePlayer.isPlaying {
                // already playing
//                thePlayer.volume = 0
                thePlayer.stop()
            } else {
            }
        }
    }
    
}
