//
//  VideoFileManager.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos


class VideoFileManager {
    

        
    func GetSubtitleList(completionHandler:@escaping ([URL]?) -> Void) {
        
        var subtitlelist = [URL]()
        do
        {
            //
            let filemanager = FileManager.default
            let folderpath = try filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let all_itemurls = try filemanager.contentsOfDirectory(at: folderpath, includingPropertiesForKeys: nil, options:  .skipsHiddenFiles)
            
            //
            DispatchQueue.global(qos: .background).async { [self] in
                
                for itemurl in all_itemurls {
                    
                    if isSubTitleFile(sender: itemurl) {
                        subtitlelist.append(itemurl)
                    }
                }
                
                //
                DispatchQueue.main.async {
                    
                    completionHandler(subtitlelist)
                }
            }
        }
        catch
        {
            print(error)
            completionHandler(nil)
        }
    }
    
    
    func isVideoFile(sender:URL?) -> Bool {
        
        guard let sender = sender else {
            return false
        }
        
        let filename = (sender.lastPathComponent) as NSString
        let pathextension = filename.pathExtension.uppercased()
        let extentions = ["3GP", "MOV", "AVI", "MP4", "WMV", "WEBM", "MKV"]
        
        var isvideofile = false
        
        for type in extentions {
            
            if type == pathextension {
                
                isvideofile = true
                break
            }
        }
        return isvideofile
    }
    
    func isSubTitleFile(sender:URL) -> Bool {
        
        let filename = (sender.lastPathComponent) as NSString
        let pathextension = filename.pathExtension.uppercased()
        return (pathextension == "SRT")
    }
    
    func isIOSSupported(sender:URL) -> Bool {
        return false
    }
    
    
    // MARK: -
    func saveVideo(_ sender:NSMutableData, withFileName name:String) {
        
        var videopath = URLManager.syncFolderURL().appendingPathComponent(name)
        videopath = self.getDublicateFileUrl(filepath: videopath)
        sender.write(toFile: videopath.path, atomically: true)
        NotificationCenter.default.post(name: .refreshLocalScreen, object: nil)
    }
    
    func copyVideoFile(_ urls:[URL]) {
        
        let folderpath = URLManager.syncFolderURL()
        
        do {
            
            for videourl in urls {
                
                //
                if isVideoFile(sender: videourl) || isSubTitleFile(sender: videourl) {
                    
                    let filename = videourl.lastPathComponent
                    var newurl = folderpath.appendingPathComponent(filename)
                    newurl = self.getDublicateFileUrl(filepath: newurl)
                    
                    try FileManager.default.moveItem(atPath: videourl.path, toPath: newurl.path)
                }
            }
            
        } catch {
            
            print("\nError\n")
        }
    }
    
    func getDublicateFileUrl(filepath:URL) -> URL {
        let documentpath = filepath.deletingLastPathComponent()
        let filename = getDublicateName(filepath: filepath)
        return documentpath.appendingPathComponent(filename)
    }
    
    func getDublicateName(filepath:URL) -> String {
        var filename = (filepath.lastPathComponent) as NSString
        let pathextension = "." + filename.pathExtension
        filename = filename.deletingPathExtension as NSString
        var newpostfix = arc4random() % 100000
        newpostfix = newpostfix + 200
        return filename as String + " \(newpostfix)" + pathextension
    }
    
    func setSubtitleFileName(subtitlepath:URL, videopath:URL) -> URL {
        return subtitlepath
    }

    
    //MARK:- Video thumb manager
    func saveVideoThumbNew(sender:UIImage?, name:String) {
        
        guard let sender = sender else {
            return
        }
   
        let thumbname = name + ".jpg"
        let thumbUrl = URLManager.videoThumbURL().appendingPathComponent(thumbname)
        let thumb_data = sender.jpegData(compressionQuality: 1)
        
        do {
            try thumb_data?.write(to: thumbUrl)
        } catch {}
    }
}

