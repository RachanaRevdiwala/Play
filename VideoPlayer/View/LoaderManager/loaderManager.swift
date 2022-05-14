//
//  Lodermaster.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import Foundation
import UIKit


var loaderView = Bundle.main.loadNibNamed("LoaderView", owner: nil, options: nil)![0] as? LoaderView

public class loaderManager {
    
  
    public class func start(progress:String? = nil, parentView:UIView? = nil) {
        
        DispatchQueue.main.async(execute: {
            
            if (parentView != nil)  {
                
                loaderView?.load(inView: parentView!, sms: progress)
                
            } else if let view = UIWindow.keyView {
                
                loaderView?.load(inView: view, sms: progress)
            }
        })
    }

    
    public class func stop() {
        
        DispatchQueue.main.async(execute: {
            
            loaderView?.unLoad()
        })
    }
}

