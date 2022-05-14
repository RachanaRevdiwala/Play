//
//  VideoSpeedView.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

public protocol VideoSpeedViewDelegate: NSObjectProtocol {
    
    func videoSpeedViewCancel()

    func videoSpeedView(chnagedVideoSpeed speed:Float)
    func videoSpeedView(chnagedAudioDealy dealy:Int)
    func videoSpeedView(chnagedSubtitleDealy dealy:Int)
    func videoSpeedView(chnagedSubtitleSize size:Float)

}

class VideoSpeedView: UIView {

    @IBOutlet var sliderStackView:UIStackView!
    @IBOutlet var cancelView:UIView!

    @IBOutlet var audioSlider:UISlider!
    @IBOutlet var audioLabel:UILabel!
    
    @IBOutlet var speedSlider:UISlider!
    @IBOutlet var speedLabel:UILabel!
    
    @IBOutlet var subtitleSlider:UISlider!
    @IBOutlet var subtitleLabel:UILabel!
    
    @IBOutlet var subtitleSizeSlider:UISlider!
    @IBOutlet var subtitleSizeLabel:UILabel!
    
    weak var delegate: VideoSpeedViewDelegate!

   
    func openSlider(audioDealy:Int, subtitleDealy:Int, speed:Float) {
        
        self.setUpUI()
        self.setSliderLimit()
                
        audioSlider.value = Float(audioDealy)
        subtitleSlider.value = Float(subtitleDealy)

        audioLabel.text = "\(audioDealy) ms"
        subtitleLabel.text = "\(subtitleDealy) ms"
        
        updateSpeedValue(speed)
    }
    
    func setUpUI(){
        cancelView.frame.size.height = MYdevice.bottomAnchor + 45

        let viewHeight = 200 + cancelView.frame.size.height
        self.frame.origin.y = UIScreen.main.bounds.height - viewHeight
        self.frame.size.height = viewHeight
        self.frame.size.width = UIScreen.main.bounds.width
        self.backgroundColor = .black.withAlphaComponent(0.9)
        
        sliderStackView.frame.size.width = min(self.frame.width - 32, 400)
        sliderStackView.center.x = self.center.x
        sliderStackView.frame.origin.y = 5
        sliderStackView.layer.cornerRadius = 5
        
        cancelView.frame.origin.y = viewHeight - cancelView.frame.size.height
    }
    
    
    func setSliderLimit() {
        audioSlider.minimumValue = -5000
        audioSlider.maximumValue = 5000
        setSlider(audioSlider)
        
        subtitleSlider.minimumValue = -5000
        subtitleSlider.maximumValue = 5000
        setSlider(subtitleSlider)
        
        subtitleSizeSlider.minimumValue = 3
        subtitleSizeSlider.maximumValue = 20
        subtitleSizeSlider.value = 12
        subtitleSizeLabel.text = "12 px"
        setSlider(subtitleSizeSlider)

        speedSlider.minimumValue = 0.25
        speedSlider.maximumValue = 4
        setSlider(speedSlider)
    }
    
    func setSlider(_ sender:UISlider) {
        sender.minimumTrackTintColor = .systemBlue
        sender.maximumTrackTintColor = .lightGray
        sender.setThumbImage(UIImage(named: "slider_thumb_white"), for: .normal)
    }
    
    @IBAction func btnCancelPressed(_ sender : UIButton) {
        self.delegate.videoSpeedViewCancel()
    }
    
    
    @IBAction func audioDealyChanged(_ sender : UISlider) {
        
        audioLabel.text = "\(Int(sender.value)) ms"
        self.delegate.videoSpeedView(chnagedAudioDealy: Int(sender.value))
    }
    
    @IBAction func sutitleDealyChanged(_ sender : UISlider) {
        subtitleLabel.text = "\(Int(sender.value)) ms"
        self.delegate.videoSpeedView(chnagedSubtitleDealy: Int(sender.value))
    }
    
    @IBAction func sutitleSizeChanged(_ sender : UISlider) {
        subtitleSizeLabel.text = NSString(format: "%.1f", sender.value) as String + " px"
        self.delegate.videoSpeedView(chnagedSubtitleSize: 19.0 - sender.value)
    }
    
    @IBAction func videoSpeedChanged(_ sender : UISlider) {
        updateSpeedValue(sender.value)
        self.delegate.videoSpeedView(chnagedVideoSpeed: sender.value)
    }
    
    func updateSpeedValue(_ sender:Float) {
        speedSlider.value = sender
        speedLabel.text = NSString(format: "%.2f", sender) as String + "x"
    }
}

