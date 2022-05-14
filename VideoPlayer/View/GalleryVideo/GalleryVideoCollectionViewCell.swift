//
//  GalleryVideoCollectionViewCell.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos

class GalleryVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var thumbImageView : UIImageView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var durationLabel : UILabel!
    @IBOutlet var selectedView : UIView!
    @IBOutlet var selectedButton : UIButton!
    
    
    internal var imageManager: PHImageManager?
    private var currentRequest: PHImageRequestID?
    
    internal var labelManager: PHImageManager?
    private var currentlabelRequest: PHImageRequestID?

    fileprivate var shouldUpdateImage = false
    fileprivate var shouldUpdateLabel = false
    
    
    internal var imageSize: CGSize = CGSize(width: 100, height: 100) {
        didSet {
            guard self.imageSize != oldValue else {
                return
            }
            self.shouldUpdateImage = true
        }
    }
    
    internal var asset: PHAsset? {
        didSet {
            guard self.asset != oldValue || self.thumbImageView.image == nil else {
                return
            }
            self.accessibilityLabel = asset?.accessibilityLabel
            self.shouldUpdateImage = true
            self.shouldUpdateLabel = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbImageView.image = nil
        self.titleLabel.text = nil
        self.durationLabel.text = nil
        //
        if let currentRequest = self.currentRequest {
            let imageManager = self.imageManager ?? PHImageManager.default()
            imageManager.cancelImageRequest(currentRequest)
        }
        
        //
        if let currentlabelRequest = self.currentlabelRequest {
            let labelManager = self.labelManager ?? PHImageManager.default()
            labelManager.cancelImageRequest(currentlabelRequest)
        }
    }

    
    // MARK: -
    internal func reloadContents() {
        
        if self.shouldUpdateImage {
            self.shouldUpdateImage = false
            self.startLoadingImage()
        }
  
        if self.shouldUpdateLabel {
            self.shouldUpdateLabel = false
            self.startLoadingLabel()
        }
    }
    

    fileprivate func startLoadingImage() {
        
        self.thumbImageView.image = nil

        guard let asset = self.asset else {
            return
        }
        let imageManager = self.imageManager ?? PHImageManager.default()
                
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .fast
        requestOptions.isSynchronous = false
        self.thumbImageView.image = nil
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            autoreleasepool {
                let scale = UIScreen.main.scale > 2 ? 2 : UIScreen.main.scale
                guard let targetSize = self?.imageSize.scaled(with: scale), self?.asset?.localIdentifier == asset.localIdentifier else {
                    return
                }
                self?.currentRequest = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                    DispatchQueue.main.async {
                        autoreleasepool {
                            guard let image = image, self?.asset?.localIdentifier == asset.localIdentifier else {
                                return
                            }
                                                    
                            //
                            self?.thumbImageView.contentMode = .scaleAspectFill
                            self?.thumbImageView.image = image

                        }
                    }
                }
            }
        }
    }
    
    
    fileprivate func startLoadingLabel() {
        
        self.titleLabel.text = nil
        self.durationLabel.text = nil
        
        guard let asset = self.asset else {
            return
        }
        
        let labelManager = self.labelManager ?? PHImageManager.default()
        let requestOptions: PHVideoRequestOptions = PHVideoRequestOptions()
        requestOptions.version = .original
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            autoreleasepool {
                guard self?.asset?.localIdentifier == asset.localIdentifier else {
                    return
                }
                
                self?.currentlabelRequest  = labelManager.requestAVAsset(forVideo: asset, options: requestOptions, resultHandler: {(urlasset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
          
                    DispatchQueue.main.async {
                        autoreleasepool {
                            guard let urlasset = urlasset, self?.asset?.localIdentifier == asset.localIdentifier else {
                                return
                            }
                            
                            let url_Asset = urlasset as? AVURLAsset
                            if  url_Asset != nil {
                                let localVideoUrl = url_Asset!.url as URL
                                self?.titleLabel.text = (localVideoUrl.lastPathComponent as NSString).deletingPathExtension
                                self?.durationLabel.text = url_Asset!.duration.durationFormat()
                            }
                        }
                    }
                })
            }
        }
    }
    
    
    
    // MARK: -
    func isSelectedVideo(_ sender:Bool) {
        
        if sender {
            selectedView.backgroundColor = .systemOrange.withAlphaComponent(0.5)
            selectedButton.setImage(UIImage(named: "seleted_cell"), for: .normal)
        } else {
            selectedView.backgroundColor = .clear
            selectedButton.setImage(UIImage(named: "unseleted_cell"), for: .normal)
        }
    }
}



extension CGSize {
    
    internal func scaled(with scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}
