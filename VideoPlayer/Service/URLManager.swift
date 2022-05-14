//
//  URLManager.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import Foundation

enum URLManager {
    
    static func pathForAppSupportDirectory() -> URL {
        
        var appSupportDir:URL?
        do{
            appSupportDir = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            
        }
        return appSupportDir!
    }
    
    
    static func videoThumbURL() -> URL  {
        pathForAppSupportDirectory().appendingPathComponent("VideoThumb")
    }
     
    static func sanpShortTempURL() -> URL  {
        pathForAppSupportDirectory().appendingPathComponent("SanpShort")
    }

    
    static func syncFolderURL() -> URL {
        URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    }

}



extension URL {
    
    func fileName() -> String {
        var filename = (self.lastPathComponent) as NSString
        filename = filename.deletingPathExtension as NSString
        return filename as String
    }
    
     func changeFileName(_ newname:String) -> URL {
        let currentfilename = (self.lastPathComponent) as NSString
        let pathextension = "." + currentfilename.pathExtension
        var newurl = self
        newurl.deleteLastPathComponent()
        return newurl.appendingPathComponent(newname+pathextension)
    }
    
    @discardableResult func rename(_ newname:String)->Bool{
        

        do {
            let basePath = self.deletingLastPathComponent()
            let destinationPath = basePath.appendingPathComponent(newname)
            try FileManager.default.moveItem(at:self, to: destinationPath)
            return true
        } catch { return false }
    }

    @discardableResult func createFolder()->Bool{

        let filemanger = FileManager.default
   
        //
        do {
            try filemanger.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch { return false }
    }

    @discardableResult func deleteItem()->Bool{
        let filemanger = FileManager.default
        if filemanger.fileExists(atPath: self.path){
            do{
                try filemanger.removeItem(atPath: self.path)
                return true
            }catch{ return false }
        }else{ return false}
    }
    
    
}


