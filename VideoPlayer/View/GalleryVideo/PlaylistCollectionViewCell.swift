//
//  PlaylistCollectionViewCell.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var thumbImageView : UIImageView!
    @IBOutlet private var titleLabel : UILabel!
    @IBOutlet private var countLabel : UILabel!
    
    @IBOutlet internal var selectedView : UIView!
    @IBOutlet private var selectedButton : UIButton!

    
    // MARK: -
    internal func isSelectedVideo(_ sender:Bool) {
        
        if sender {
            selectedView.backgroundColor = .systemOrange.withAlphaComponent(0.3)
            selectedButton.setImage(UIImage(named: "seleted_cell"), for: .normal)
        } else {
            selectedView.backgroundColor = .clear
            selectedButton.setImage(UIImage(named: "unseleted_cell"), for: .normal)
        }
    }
    
    internal var playlistAlbum:PlaylistAlbum? {
        didSet {

            self.thumbImageView.layer.cornerRadius = 2
            self.thumbImageView.backgroundColor = .tableRow()
            self.thumbImageView.image = nil
            self.titleLabel.text = self.playlistAlbum?.name
            self.countLabel.text = "\(self.playlistAlbum!.count)" + " Track"
            setThumbImage()
        }
    }
    
    internal func setThumbImage() {
        
        guard self.playlistAlbum?.count != 0 else {
            return
        }
        
        let thumburl = self.playlistAlbum!.getThumbUrl()
        if FileManager.default.fileExists(atPath: thumburl.path) {
            self.thumbImageView.image = UIImage(contentsOfFile:thumburl.path)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
