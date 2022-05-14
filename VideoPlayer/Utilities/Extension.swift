//
//  Constant.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import Foundation
import UIKit
import Photos



extension Notification.Name {
    
    static let refreshLocalScreen = Notification.Name("RefreshLocalFileScreen")
    static let refreshFolderScreen = Notification.Name("RefreshFolderScreen")
    static let refreshPlaylistScreen = Notification.Name("RefreshPlayListScreen")
    static let playNewVideo = Notification.Name("playNewVideo")
    static let pauseOldVideo = Notification.Name("pauseOldVideo")

    static let applockScreenKeyBoard = Notification.Name("applockScreenKeyBoard")

    static let didReceiveVideo = Notification.Name("didReceiveVideo")
    static let didCloseLockScreen = Notification.Name("didCloseLockScreen")
}




enum StringManager {
    
    
    static let downloadTitle = "Enter an address to download the file to \nyour iPhone."
    
    static let downloadPlaceHolder = "http://myserver.com/file.mkv"
    
    static let syncText = "Connect your device to iTunes and select your device.\nSelect \"File Sharing\" on the left side menu of iTunes and look for VideoPlayer to transfer files"
        
    static let syncOtherAppText = "Connect your device to iTunes and select your device. Select \"File Sharing\" on the left side menu of iTunes and look for VideoPlayer to transfer files"
}


struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}


extension UIImage {
    
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
   static func makeRound(size:Int, color:UIColor) -> UIImage? {
    
        let imgsize = CGSize(width: size, height: size)
    
        UIGraphicsBeginImageContextWithOptions(imgsize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: imgsize)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}


extension UIView {

    
    func takeScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func setTopNavigation() {
        self.frame.size.height = 64 + 10
        self.backgroundColor = .tableRow()
    }   
}


extension FileManager {
    
    @discardableResult func secureCopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }
    
    @discardableResult func moveFile(pre: String, move: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: pre, toPath: move)
            return true
        } catch {
            return false
        }
    }
    
    
    @discardableResult func moveFileFolder(pre: URL, move: URL) -> URL? {
        do {
            let filename = pre.lastPathComponent
            var new_file_url = move.appendingPathComponent(filename)
            
            // dublicate create
            if FileManager.default.fileExists(atPath: new_file_url.path) {
                new_file_url = VideoFileManager().getDublicateFileUrl(filepath: new_file_url)
            }
            
            try FileManager.default.moveItem(atPath: pre.path, toPath: new_file_url.path)
            return new_file_url
        } catch {
            return nil
        }
    }
}


extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var intValue:Int {
        
        if isInt {
            return Int(self)!
        }
        return 0
    }
    
    func trimWhiteSpaec()->String{ return self.trimmingCharacters(in: NSCharacterSet.whitespaces)}
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    
    func toSecondFloat() -> Float {
        let second = self.toSecond()
        return (second as NSString).floatValue
    }
    
    func toSecond() -> String {
        
        guard self != "" else {
            return "0"
        }
        
        
        let finalstrtime = self.replacingOccurrences(of: "-", with: "")
        let arrTime = finalstrtime.components(separatedBy: ":")
        var hours  = 0
        var minit = 0
        var sec = 0
        
        //
        if arrTime.count == 3 {
            
            hours = arrTime[0].intValue
            minit = arrTime[1].intValue
            sec = arrTime[2].intValue
        }
        
        //
        if arrTime.count == 2 {

            minit = arrTime[0].intValue
            sec = arrTime[1].intValue
        }
        
        let total_second = hours * 3600 + minit * 60 + sec
        
        return "\(total_second)"
    }
    
}


extension Int {
    
    func toMilisecond() -> Int {
        
        if self != 0 {
           return self/1000
        }
        
        return self
    }
    
    func toMicrosecond() -> Int {
        
        if self != 0 {
           return self*1000
        }
        
        return self
    }
}


extension Date {
    
    var timeStamp: String {
        return "\(ticks)"
    }
    
    var ticks: UInt64 {
        return UInt64(Int((self.timeIntervalSince1970 * 1000.0).rounded()))
    }
}


extension UIWindow {
    
    static var keyView: UIWindow? {
        return UIApplication.shared.windows[0]
    }

    static var isLandscape: Bool {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
    }
}


extension UIViewController {
    
    static func changeOrientation() {
        
        var value : Int = UIInterfaceOrientation.landscapeRight.rawValue
        if UIWindow.isLandscape {
            value = UIInterfaceOrientation.portrait.rawValue
        }
        
        UIDevice.current.setValue(value, forKey: "orientation")
        self.attemptRotationToDeviceOrientation()
    }
    
    func makeNavigation()->UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
