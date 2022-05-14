//
//  Videofile.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import Foundation
import MediaPlayer


struct Videofile {
    
    var url : URL
    var name : String
    var duration : String
    var isiOSSupported = true
    var databaseId = 0
    var displayOrder = 0
    
    func getThumbUrl() -> URL {
        URLManager.videoThumbURL().appendingPathComponent(name+".jpg")
    }
    
    func durationMinit() -> Float {
        
        let timearray = duration.split(separator: ":")
        
        guard timearray.count > 0 else {
            return 0
        }
        
        if timearray.count == 3 {
            
            let hour = Float(timearray[0])!
            let minit = Float(timearray[1])!
            let second = Float(timearray[2])!
            return (hour*60) + minit + (second/60)
        }
        
        let minit = Float(timearray[0])!
        let second = Float(timearray[1])!
        return minit + (second/60)
    }
}


struct PlaylistAlbum {
    
    let id:Int
    var name:String
    var count:Int
    var thumbName = ""
    
    func getThumbUrl() -> URL {
        URLManager.videoThumbURL().appendingPathComponent(thumbName+".jpg")
    }
}


class BrightVolumManager {
    
    var brightness:Float = Float(UIScreen.main.brightness)
    var volume = AVAudioSession.sharedInstance().outputVolume
    
    func changeBrightness(_ sender:Float) -> Int {
        
        brightness = brightness + (sender * 0.080)
        
        if brightness < 0 {
            brightness = 0
        }
        
        if brightness > 1 {
            brightness = 1
        }
        
        UIScreen.main.brightness = CGFloat(brightness)
        return Int(brightness * 100)
    }
    
    func changeVolume(_ sender:Float) -> Int {
        
        volume = volume + (sender * 0.080)
                
        if volume < 0 {
            volume = 0
        }
        
        if volume > 1 {
            volume = 1
        }
        
        
        let volumeView = MPVolumeView(frame: .zero)
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) { [self] in
            slider?.value = volume
        }
        
        return Int(volume*100)
    }
    
    
}


