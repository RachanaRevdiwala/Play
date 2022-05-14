//
//  VLCVideoPlayerVC.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos
import MediaPlayer
import MobileVLCKit


class VLCVideoPlayerVC: UIViewController, VLCMediaPlayerDelegate {
    
    enum MenuType {
        case allhide
        case singleTapGesture
        case doubleTapGesture
        case panGesture
        case actionSheet
    }
    
    
    var videoAssetArray = PHFetchResult<PHAsset>()
    var videoUrlArray = [Videofile]()
    
    var CurrentMenu:MenuType = .allhide
    
    
    
    //
    enum PanGestureDirection: Int {
        case vertical
        case horizontal
    }
    var panGestureDirection:PanGestureDirection = .horizontal
    
    
    //
    @IBOutlet var viewVLCPlayer : UIView!
    @IBOutlet var viewVLCController : UIView!
    @IBOutlet var topNaviView : UIView!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var lblVideoName : UILabel!
    @IBOutlet var optionMenuView : UIView!
    @IBOutlet var btnLock : UIButton!
    @IBOutlet var btnScreensort : UIButton!
    @IBOutlet var btnPlay : UIButton!
    @IBOutlet var bottomNaviView : UIView!
    @IBOutlet var sliderVideo : UISlider!
    @IBOutlet var lblStartTime : UILabel!
    @IBOutlet var btnSpeed : UIButton!
    @IBOutlet var btnBackWard : UIButton!
    @IBOutlet var btnForWard : UIButton!
    @IBOutlet var lblEndTime : UILabel!
    @IBOutlet var btnfullScreen : UIButton!
    @IBOutlet var btnAudio : UIButton!
    @IBOutlet var btnShuffle : UIButton!
    @IBOutlet var btnOpenLock : UIButton!
    @IBOutlet var brightVolumeView : UIView!
    @IBOutlet var brightVolumeButImage : UIButton!
    @IBOutlet var brightVolumeLabel : UILabel!
    @IBOutlet var leftTapView : UIView!
    @IBOutlet var rightTapView : UIView!
    @IBOutlet var videoJumpView : UIView!
    @IBOutlet var jumpButtonImage : UIButton!
    @IBOutlet var playPuseView : UIView!


    
    let brivolManger = BrightVolumManager()
    
    let sliderView = Bundle.main.loadNibNamed("VideoSpeedView", owner: nil, options: nil)![0] as? VideoSpeedView
    let audioTrackView = Bundle.main.loadNibNamed("AudioTrackView", owner: nil, options: nil)![0] as? AudioTrackView
    
    var indexOfURL = 0
   
    //
    enum AfterAdClose {
        case nextVideo, backScreen
    }
    private var afterAdClose:AfterAdClose = .backScreen
    
    
    //
    enum ShuffleType {
        
        case allOne, onlyOne, roundround
        
        func buttonimage() -> String {
            switch self {
            case .allOne:  return "menu_allone"
            case .onlyOne: return "menu_onlyone"
            case .roundround:   return "menu_roundround"
            }
        }
    }
    private var shuffleType:ShuffleType = .allOne
    
    
    var myPlayer = VLCMediaPlayer()
    
    // statusbar
    var statusBarState = false
    override var prefersStatusBarHidden: Bool{
        return statusBarState
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderView?.delegate = self
        audioTrackView?.delegate = self
        
        self.setUpUI()
        self.Gestures()
        self.volumeviewhide(self.view)

        self.perform(#selector(BackWard_ForWard_Handle), with: self, afterDelay: 1)
    }
    
    func volumeviewhide(_ currentView:UIView) {
        let volumeview = MPVolumeView()
        currentView.insertSubview(volumeview, at: 0)
        volumeview.alpha = 0.0001
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseOldVideo), name: .pauseOldVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playNewVideoDirect(_:)), name: .playNewVideo, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.removeObserver(self)
    }

    
    
    // MARK: -
    
    func setUpUI() {
        btnBack.tintColor = .white
        btnOpenLock.isHidden = true
        btnOpenLock.tintColor = .white
        btnPlay.tintColor = .white
        btnBackWard.tintColor = .white
        btnForWard.tintColor = .white
        lblStartTime.textColor = .lightGray
        lblEndTime.textColor = .lightGray
        btnfullScreen.tintColor = .white
        resetSlider()
        brightVolumeView.isHidden = true
        brightVolumeLabel.textColor = .white
        brightVolumeLabel.backgroundColor = .black.withAlphaComponent(0.3)
        brightVolumeLabel.layer.cornerRadius = 5
        brightVolumeButImage.tintColor = .white
        brightVolumeButImage.layer.cornerRadius = brightVolumeButImage.frame.size.width / 2
        videoJumpView.isHidden = true
        videoJumpView.backgroundColor = .offBlack()
        videoJumpView.layer.cornerRadius = 5
        setOptionMenuView()
        myPlayer.drawable = viewVLCPlayer
        myPlayer.delegate = self
        myPlayer.audio!.volume = 100
    }
    
    func resetSlider() {
        
        let thumbImg = UIImage.makeRound(size: 20, color: .themecolor())
        sliderVideo.setThumbImage(thumbImg, for: .normal)
        sliderVideo.maximumTrackTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        sliderVideo.minimumTrackTintColor = .themecolor()
    }
    
    @objc func playerSetUP() {
        
        // preper video
        self.getVidedetail { [self] video_detail in
            
            //
            let my_media = VLCMedia(path: video_detail.url.path)
            myPlayer.media = my_media
            myPlayer.rate = 1.0
            myPlayer.play()
            let sliderValue = video_detail.duration.toSecondFloat()
            sliderVideo.maximumValue = sliderValue
            lblVideoName.text = "\(video_detail.name)"
            perform(#selector(Hide), with: nil, afterDelay: 9)
        }
    }
    
    
    
    func getVidedetail(complition:@escaping (Videofile)->()) {
        
        if videoUrlArray.count == 0 {
            
            let phasset = videoAssetArray[indexOfURL]
            loaderManager.start()
            self.getVideoDetail(sender: phasset) { responseVideoDetail in
       
                DispatchQueue.main.async {
                    
                    guard responseVideoDetail != nil else {
                        return
                    }
                    
                    complition(responseVideoDetail!)
                    loaderManager.stop()
                }
            }
        }
    }
    
    func getVideoDetail(sender:PHAsset, completionHandler : @escaping ((_ responseVideoDetail : Videofile?) -> Void)) {
        
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .original
        
        DispatchQueue.global(qos: .background).async {
       
            PHImageManager.default().requestAVAsset(forVideo: sender, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                
                //
                let urlAsset = asset as? AVURLAsset
                
                //
                let localVideoUrl = urlAsset!.url as URL
                let filename = (localVideoUrl.lastPathComponent as NSString).deletingPathExtension
                let videoduration = urlAsset!.duration.durationFormat()
                let videodetail = Videofile(url: localVideoUrl, name: filename, duration: videoduration)
                completionHandler(videodetail)
            })
        }
    }
    
    
    @objc func BackWard_ForWard_Handle() {
        
        let totalvideo = videoUrlArray.count == 0 ? videoAssetArray.count : videoUrlArray.count
        
 
            
            if indexOfURL < 0 {
                indexOfURL = totalvideo-1
            }
            
            if indexOfURL >= totalvideo {
                indexOfURL = 0
            }
        
        
        guard indexOfURL < totalvideo && indexOfURL >= 0 else {
            btnBackPressed(btnBack)
            return
        }
        
        playerSetUP()
        btnBackWardForWardManage()
    }
    
    private func btnBackWardForWardManage(){
        
        btnBackWard.isEnabled = true
        btnForWard.isEnabled = true
        
        
        if indexOfURL == 0 {
            btnBackWard.isEnabled = false
        }
        
        
        let totalvideo = videoUrlArray.count == 0 ? videoAssetArray.count : videoUrlArray.count
        if indexOfURL == totalvideo-1 {
            btnForWard.isEnabled = false
        }
    }
    
    
    // MARK: -
    
    @IBAction func btnBackPressed(_ sender : UIButton) {
        
        myPlayer.stop()

        AppUtility.lockOrientation(.portrait)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        
        guard self.navigationController == nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSpeedPressed(_ sender : UIButton) {
        Hide()
        SpeedAddAsChild()
    }
    
    @IBAction func btnAudioTrackPressed(_ sender : UIButton) {
        Hide()
        AudioTrackAddAsChild()
    }
    
    @IBAction func btnLockUnlockPressed(_ sender : UIButton) {
        
        if sender.tag == 0 {
            
            viewVLCController.isHidden = true
            btnOpenLock.isHidden = false
            return
        }
        
        viewVLCController.isHidden = false
        btnOpenLock.isHidden = true
    }
    
    @IBAction func btnShufflePressed(_ sender : UIButton) {
        
        switch shuffleType {
        case .allOne:  shuffleType = .onlyOne
        case .onlyOne: shuffleType = .roundround
        case .roundround:   shuffleType = .allOne
        }
        
        sender.setImage(UIImage(named: shuffleType.buttonimage()), for: .normal)
    }
    
    
    @IBAction func btnScreenSortPressed(_ sender : UIButton) {
        myPlayer.saveVideoSnapshot(at: URLManager.sanpShortTempURL().path, withWidth: 0, andHeight: 0)
    }
    
    @IBAction func btnFullScreenPressed(_ sender : UIButton) {
        UIViewController.changeOrientation()
    }
    
    
    
    @IBAction internal func btnPlayPressed(_ sender : Any) {
        videoPlay = !videoPlay
    }
    
    internal var videoPlay:Bool = true {
        didSet {
            if self.videoPlay {
                
                let pauseImage = UIImage(named: "player_pause")
                btnPlay.setImage(pauseImage, for: .normal)
                myPlayer.play()
                
            } else {
                
                let playImage = UIImage(named: "player_play")
                btnPlay.setImage(playImage, for: .normal)
                myPlayer.pause()
                ShowControllers()
            }
        }
    }
    
    @IBAction func btnBackWardPressed(_ sender : UIButton) {
        self.indexOfURL -= 1

        BackWard_ForWard_Handle()
    }
    
    @IBAction func btnForWardPressed(_ sender : UIButton) {
        self.indexOfURL += 1

        BackWard_ForWard_Handle()
    }
    
    //MARK:-
    
    @objc private func pauseOldVideo() {
       videoPlay = false
       HideControllers()
    }
    
    @objc private func playNewVideoDirect(_ notification: Notification) {
        
        if let data = notification.userInfo as? [String: Videofile] {
            
            if myPlayer.isPlaying {
                myPlayer.pause()
            }
            
            if videoUrlArray.count == 0 {
                videoAssetArray = PHFetchResult<PHAsset>()
            }
            
            //
            videoUrlArray.append(data["newvideo"]!)
            indexOfURL = videoUrlArray.count - 1
            BackWard_ForWard_Handle()
        }
    }
    
    @objc private func playNewVideoDirect(){
    
        if myPlayer.isPlaying {
            myPlayer.pause()
        }
    }

    
    func mediaPlayerStateChanged(_ aNotification: Notification) {

        if myPlayer.state == .ended
        {
            self.btnForWardPressed(btnForWard)
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification)
    {
        lblStartTime.text = myPlayer.time.stringValue
        
        //
        if lblEndTime.text == "00:00" || lblEndTime.text == ":" {
            lblEndTime.text = myPlayer.media!.length.stringValue ?? "00:00"
            lblEndTime.text = lblEndTime.text!.replacingOccurrences(of: "-", with: "")
        }
        

        // if time is not loaded
        if sliderVideo.maximumValue == 0 || sliderVideo.maximumValue < sliderVideo.value {
            let maxvalue = myPlayer.remainingTime?.stringValue.toSecondFloat()
            sliderVideo.maximumValue = maxvalue!
        }
        
        
        let slidervalue = myPlayer.time.stringValue.toSecondFloat()
        sliderVideo.value = slidervalue
    }
    
    
    
    func mediaPlayerSnapshot(_ aNotification: Notification) {
        
        let kk = myPlayer.lastSnapshot
        
        if kk != nil {
            UIImageWriteToSavedPhotosAlbum(kk!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    
    //
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        guard error == nil else {
            return
        }
        
        let tostlabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 70))
        tostlabel.center = CGPoint(x: self.view.center.x-10, y: self.view.center.y + 100)
        tostlabel.backgroundColor = .offBlack()
        tostlabel.text = "Saved to Gallery"
        tostlabel.textAlignment = .center
        tostlabel.textColor = .white
        tostlabel.font = UIFont.systemFont(ofSize: 18)
        tostlabel.layer.cornerRadius = 35
        tostlabel.clipsToBounds = true
        
        self.view.addSubview(tostlabel)
        self.perform(#selector(hideTostview(_:)), with:tostlabel, afterDelay: 1.5)
    }
    
    @objc func hideTostview( _ sender:UILabel){
        sender.removeFromSuperview()
    }
}


extension VLCVideoPlayerVC {
    
    func Show()
    {
        
        switch CurrentMenu {
        
        case .singleTapGesture:
            ShowControllers()
            break
            
        case .doubleTapGesture:
            videoJumpView.isHidden = false
            break
            
        case .panGesture:
            brightVolumeView.isHidden = false
            break
            
        case .allhide:
            break
            
        case .actionSheet:
            break
        }
    }
    
    @objc func Hide()
    {
        HideControllers()
        sliderView?.removeFromSuperview()
        audioTrackView?.removeFromSuperview()
        CurrentMenu = .allhide
    }
    
    
    @objc func ShowControllers() {
        
        topNaviView.isHidden = false
        bottomNaviView.isHidden = false
        btnPlay.isHidden = false
        btnBackWard.isHidden = false
        btnForWard.isHidden = false
        optionMenuView.isHidden = false
        
        statusBarShowHide(sender: false)
        
        perform(#selector(Hide), with: nil, afterDelay: 10)
    }
    
    @objc func HideControllers() {
        
        topNaviView.isHidden = true
        bottomNaviView.isHidden = true
        btnPlay.isHidden = true
        btnBackWard.isHidden = true
        btnForWard.isHidden = true
        optionMenuView.isHidden = true
        brightVolumeView.isHidden = true
        videoJumpView.isHidden = true
        
        statusBarShowHide(sender: true)
    }
    
    
    func statusBarShowHide(sender:Bool) {
        
        statusBarState = sender
        
        if UIWindow.isLandscape {
            statusBarState = true
        }
        self.setNeedsStatusBarAppearanceUpdate()

    }

}

extension VLCVideoPlayerVC:AudioTrackViewDelegate, SubtitleListDelegate, VideoSpeedViewDelegate {
    
    func SpeedAddAsChild() {
        
        let audio_delay = myPlayer.currentAudioPlaybackDelay.toMilisecond()
        let subtitle_dealy = myPlayer.currentVideoSubTitleDelay.toMilisecond()
        sliderView?.openSlider(audioDealy: audio_delay, subtitleDealy: subtitle_dealy, speed: myPlayer.rate)
        self.view.addSubview(sliderView!)
    }
    
    func AudioTrackAddAsChild() {
        
        guard audioTrackView != nil else {
            return
        }

        var current_audio = Int(myPlayer.currentAudioTrackIndex)
        current_audio = max(0, current_audio)
        
        //
        var current_subtitle = 0
        for sub_title_index in myPlayer.videoSubTitlesIndexes {
            
            if sub_title_index as! Int == Int(myPlayer.currentVideoSubTitleIndex) {
                break
            }
            current_subtitle += 1
        }

        
        audioTrackView?.openTrackWithData(audiolist: myPlayer.audioTrackNames as? [String] ?? [], selectedaudio: current_audio, subtitlelist: myPlayer.videoSubTitlesNames as? [String] ?? [], selectedsubtitle: current_subtitle)
        
        self.view.addSubview(audioTrackView!)
    }
    
    
    //MARK:-
    
    func videoSpeedViewCancel() {
        Hide()
    }
    
    func videoSpeedView(chnagedAudioDealy dealy: Int) {
        self.myPlayer.currentAudioPlaybackDelay = dealy.toMicrosecond()
    }
    
    func videoSpeedView(chnagedSubtitleDealy dealy: Int) {
        self.myPlayer.currentVideoSubTitleDelay = dealy.toMicrosecond()
    }
    
    func videoSpeedView(chnagedSubtitleSize size: Float) {
        self.myPlayer.perform(Selector(("setTextRendererFontSize:")), with: size)
    }
    
    func videoSpeedView(chnagedVideoSpeed speed: Float) {
        self.myPlayer.rate = speed
    }
    

    
    //MARK:-
    func subtitleListViewAddNewFile() {
    }

    
    func subtitleListView(didAddSubtitleTrack sender: URL) {
        let subtitle_url = VideoFileManager().setSubtitleFileName(subtitlepath: sender, videopath: myPlayer.media!.url)
        myPlayer.addPlaybackSlave(subtitle_url, type: .subtitle, enforce: true)
    }
    
    
    //MARK:-
    func audioTrackViewCancel() {
        Hide()
    }
    
    func audioTrackViewAddSubtitlefile() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubtitleListViewController") as? SubtitleListViewController
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    func audioTrackView(didChangeAudioTrack index: Int) {
        let new_audio_track = index == 0 ? -1 : index
        self.myPlayer.currentAudioTrackIndex = Int32(new_audio_track)
    }
    
    func audioTrackView(didChangeSubtitleTrack index: Int) {
        self.myPlayer.currentVideoSubTitleIndex = myPlayer.videoSubTitlesIndexes[index] as! Int32
    }
}


extension VLCVideoPlayerVC {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [self] context in
            
            sliderView?.removeFromSuperview()
            audioTrackView?.removeFromSuperview()
                        
            if UIWindow.isLandscape {
                
                let optionMenu_width:CGFloat = 260
                
                statusBarShowHide(sender: true)
                lblVideoName.frame.size.width = self.view.bounds.width - 55 - optionMenu_width
                
                //
                topNaviView.frame.origin.y = 0
                bottomNaviView.frame.size.height = 70
                bottomNaviView.frame.origin.y = self.view.frame.height - bottomNaviView.frame.height
                
                //
                optionMenuView.frame = CGRect(x: self.view.frame.width - optionMenu_width, y: 0, width: optionMenu_width, height: 50)
                let butsize =  CGSize(width: 50, height: 50)
                btnScreensort.frame = CGRect(origin: CGPoint(x: 145, y: 0), size: butsize)
                btnShuffle.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: butsize)
                btnSpeed.frame = CGRect(origin: CGPoint(x: 96, y: 0), size: butsize)
                btnLock.frame = CGRect(origin: CGPoint(x: 195, y: 0), size: butsize)
                btnAudio.frame = CGRect(origin: CGPoint(x: 48, y: 0), size: butsize)

                btnOpenLock.frame.origin.y = 0
                
            } else {
                
                statusBarShowHide(sender: false)
                setOptionMenuView()
            }
        })
    }
    
    
    func setOptionMenuView() {
        
        let optionMenu_height:CGFloat = 260

        //
        let topypoint = 20 + MYdevice.topAnchor
        topNaviView.frame.origin.y = topypoint
        lblVideoName.frame.size.width = self.view.bounds.width - 105

        //
        let bottomspace = MYdevice.bottomAnchor == 0 ? 10 :  MYdevice.bottomAnchor
        bottomNaviView.frame.size.height = 60 + bottomspace
        bottomNaviView.frame.origin.y = self.view.frame.height - bottomNaviView.frame.height
        
        //
        optionMenuView.frame = CGRect(x: self.view.frame.width - 50, y: topypoint, width: 50, height: optionMenu_height)
        
        
        let butsize =  CGSize(width: 50, height: 50)
        btnScreensort.frame = CGRect(origin: CGPoint(x: 0, y: 49), size: butsize)
        btnAudio.frame = CGRect(origin: CGPoint(x: 0, y: 146), size: butsize)
        btnLock.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: butsize)
        btnShuffle.frame = CGRect(origin: CGPoint(x: 0, y: 194), size: butsize)
        btnSpeed.frame = CGRect(origin: CGPoint(x: 0, y: 97), size: butsize)

        btnOpenLock.frame.origin.y = topypoint
    }
    
    
}
   
    

extension VLCVideoPlayerVC: UIGestureRecognizerDelegate {
   
    
    func Gestures() {
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnSingleTapPressed(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        viewVLCController.addGestureRecognizer(singleTapGesture)
        var RighttapGesture = UITapGestureRecognizer()
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnPlayPressed(_:)))
        doubleTapGesture.numberOfTouchesRequired = 2
        var LefttapGesture = UITapGestureRecognizer()
        LefttapGesture = UITapGestureRecognizer(target: self, action: #selector(btnBackwardPressed(_:)))
        LefttapGesture.numberOfTapsRequired = 2
        viewVLCController.addGestureRecognizer(doubleTapGesture)
        RighttapGesture = UITapGestureRecognizer(target: self, action: #selector(btnForwarfTap(_:)))
        leftTapView.addGestureRecognizer(LefttapGesture)
        leftTapView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(onPanGesture(_:)))
        RighttapGesture.numberOfTapsRequired = 2
        rightTapView.addGestureRecognizer(RighttapGesture)
        rightTapView.isUserInteractionEnabled = true
        singleTapGesture.require(toFail: RighttapGesture)
        singleTapGesture.require(toFail: LefttapGesture)
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        viewVLCController.addGestureRecognizer(panGesture)
    }
    
    @objc open func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: viewVLCController)
        let location = gesture.location(in: viewVLCController)
        let velocity = gesture.velocity(in: viewVLCController)
        
        switch gesture.state {
        case .began:
            Hide()
            let x = abs(translation.x)
            let y = abs(translation.y)
            if x < y
            {
                panGestureDirection = .vertical
                panManager(location: location, velocity: velocity)
            }
            else if x > y
            {
                panGestureDirection = .horizontal
            }
            
            
        case .changed:
            switch panGestureDirection
            {
            case .horizontal: break
            case .vertical:
                panManager(location: location, velocity: velocity)
            }
            
            
        case .ended:
            switch panGestureDirection
            {
            case .horizontal: break
            case .vertical:
                panManager(location: location, velocity: velocity)
                perform(#selector(Hide), with: nil, afterDelay: 2)
            }
            
        default:
            break
        }
    }
            
    func panManager(location : CGPoint, velocity : CGPoint) {
        CurrentMenu = .panGesture
        Show()
        
        let changeValue:Float = velocity.y > 0 ? -1 : 1


        if location.x > viewVLCController.bounds.width / 2
        {
            brightVolumeButImage.setImage(UIImage(named: "pan_volume"), for: .normal)
            brightVolumeButImage.backgroundColor = .systemOrange.withAlphaComponent(1)
            brightVolumeLabel.text = "\(brivolManger.changeVolume(changeValue))%"
        }
        else
        {
            brightVolumeButImage.setImage(UIImage(named: "pan_brightness"), for: .normal)
            brightVolumeButImage.backgroundColor = .systemBlue.withAlphaComponent(1)
            brightVolumeLabel.text = "\(brivolManger.changeBrightness(changeValue))%"
        }
    }
    
    
    @IBAction func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        
        let currentSec = Int(myPlayer.time.stringValue.toSecondFloat())
        let newSecond = Int(playbackSlider.value)
        
      
        if currentSec > newSecond
        {
            myPlayer.jumpBackward(Int32(currentSec - newSecond))
        }
        else
        {
            myPlayer.jumpForward(Int32(newSecond - currentSec))
        }
        
        if myPlayer.rate == 0
        {
            btnPlay.setImage(UIImage(named: "player_pause"), for: .normal)
            myPlayer.play()
        }
    }
        
    @objc func btnBackwardPressed(_ gesture: UITapGestureRecognizer) {
        
        Hide()
        CurrentMenu = .doubleTapGesture
        Show()
        
        myPlayer.jumpBackward(10)
        let imgArrow = UIImage(named: "jump_back")
        jumpButtonImage.setImage(imgArrow, for: .normal)
        perform(#selector(HideArrowView), with: nil, afterDelay: 1)
    }
    
    @objc func btnForwarfTap(_ gesture: UITapGestureRecognizer) {
        
        Hide()
        CurrentMenu = .doubleTapGesture
        Show()

        myPlayer.jumpForward(10)
        let imgArrow = UIImage(named: "jump_next")
        jumpButtonImage.setImage(imgArrow, for: .normal)
        perform(#selector(HideArrowView), with: nil, afterDelay: 1)
    }
    
    @objc func HideArrowView() {
        Hide()
    }
    
    @objc func btnSingleTapPressed(_ gesture: UITapGestureRecognizer) {
      
        sliderView?.removeFromSuperview()
        audioTrackView?.removeFromSuperview()

        if CurrentMenu == .allhide {
            CurrentMenu = .singleTapGesture
            Show()
        } else {
            Hide()
        }
    }
}

