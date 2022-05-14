//
//  UIColor+Extentions.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func background() -> UIColor {
        return UIColor(named: "color_background")!
    }
    
    static func themecolor() -> UIColor {
        return .systemBlue 
    }
    
    static func tableRow() -> UIColor {
        return UIColor(named: "color_tablerow")!
    }
    
    static func navigationLine() -> UIColor {
        return UIColor(named: "color_navigationLine")!
    }
    
    static func subtitle() -> UIColor {
        return UIColor(named: "color_tablesubtitle")!
    }
        
    static func offBlack() -> UIColor {
        return UIColor.black.withAlphaComponent(0.50)
    }
}
enum TableViewCellIdentifiers: String {

    case galleryFolderCell                           = "GalleryFolderCell"
    case audioTrackTableViewCell                     = "AudioTrackTableViewCell"
 
}

enum CollectionViewCellIdentifiers: String {

    case galleryVideoCollectionViewCell              = "GalleryVideoCollectionViewCell"
    

    case playlistCollectionViewCell                  = "PlaylistCollectionViewCell"
    case playlistCollectionViewCell2                 = "PlaylistCollectionViewCell2"
 

}
