//
//  MYdevice.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import SystemConfiguration

//
let isPad = UIDevice.current.userInterfaceIdiom == .pad
let screenSize = UIScreen.main.bounds


enum MYdevice {
    

    static let topAnchor = UIWindow.keyView!.safeAreaInsets.top ?? 0
    static let bottomAnchor = UIWindow.keyView?.safeAreaInsets.bottom ?? 0

    
    static func shareUserItems(_ sender:[Any], _ controller:UIViewController) {
        
        let activityVC = UIActivityViewController(activityItems: sender, applicationActivities: nil)

        if isPad {
            activityVC.popoverPresentationController?.sourceView = controller.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 200, width: 300, height: 300)
        }
        activityVC.modalPresentationStyle = .fullScreen
        controller.present(activityVC, animated: true, completion: nil)
    }
}
