//
//  AssestManager.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos

struct FolderDetail {
    let name:String
    let count:String
}

class AssestManager {
    
    func checkPhotosPermission(completion: @escaping (_ permission:Bool, _ islimited:Bool) -> Void) {
        
        if #available(iOS 14, *) {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                
                var authorized_video = status == .authorized ? true : false
                
                if (status == .limited) {
                    authorized_video = true
                }
                
                completion(authorized_video, status == .limited ? true : false)
            }
            
        } else {
            
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
                completion(status == .authorized ? true : false, false)
            })
        }
    }
    
    
    // MARK: -
    
    func fetchAlbumlist(onCompletion: @escaping ([FolderDetail], Int) -> Void)  {
        let folderlist = [FolderDetail]()
        let totalvideocount = fetchTotalVideoCountFromFolder()
        onCompletion(folderlist, totalvideocount)
    }
    
    func fetchVideoPHFetchResult(albumName:String, complition:@escaping (PHFetchResult<PHAsset>?)->()) {
        
        let fetchOptions = PHFetchOptions()
        let fetchResult:PHFetchResult<PHAsset>
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        complition(fetchResult)
        
    }

    // MARK: -
    
    func getVideoAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }
    
    
    func fetchTotalVideoCountFromFolder() -> Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        return fetchResult.count
    }
}

extension CMTime {
    
    func durationFormat() -> String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "0%i:%02i:%02i", hours, minutes, seconds)
    }
}

