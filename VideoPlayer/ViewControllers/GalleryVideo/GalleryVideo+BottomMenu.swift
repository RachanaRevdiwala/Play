//
//  GalleryVideo+BottomMenu.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos

extension GalleryVideoViewController : BottomMenuDelegate {
    
    func setBottomMenuView() {
        
        bottomMenu.frame.size.height = 60 + MYdevice.bottomAnchor
        bottomMenu.frame.size.width = screenSize.width
        bottomMenu.frame.origin.y = screenSize.height - bottomMenu.bounds.height
        bottomMenu.frame.origin.x = 0
        bottomMenu.backgroundColor = .tableRow()
        bottomMenu.isHidden = true
        
        bottomMenu.menuItems = [MenuItem(imgName: "menu_delete", menuName: "Delete")]
        bottomMenu.delegete = self
        
        //
        self.view.addSubview(bottomMenu)

    }
    
    func bottomMenu(didSelectItemAt index: Int) {
        deleteVideoFile()
    }
    
    
    // MARK: -
    
    func deleteVideoFile() {
        
        //
        guard selectedVideoCell.count != 0 else {
            return
        }
        
        
        var asset_array = [PHAsset]()
        for video_index in selectedVideoCell {
            let video_detail = videoPhAsset[video_index]
            asset_array.append(video_detail)
        }
        
        
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetChangeRequest.deleteAssets(asset_array as NSArray)

        }, completionHandler: { success, error in
            DispatchQueue.main.async { [self] in
            if success {
                GetvideoFromGallery()
                isEditVideoCell = false
                self.delegate.albumview(albumName, newVideoCount: "\(videoPhAsset.count)")
            }}
        })
    }
}
