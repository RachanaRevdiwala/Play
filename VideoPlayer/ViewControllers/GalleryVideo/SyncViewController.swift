//
//  SyncViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController {
    
    @IBOutlet var topNaviView : UIView!
    @IBOutlet var backButton : UIButton!

    @IBOutlet var guidScrollView : UIScrollView!
    @IBOutlet var titleLabel1 : UILabel!
    @IBOutlet var titleLabel2 : UILabel!
    @IBOutlet var guidImgView1 : UIImageView!
    @IBOutlet var guidImgView2 : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel1.text = "1. Sync With MAC (Big Sur, Catalina)"
        titleLabel2.text = "2. Sync With MAC (Mojave)"
        
        self.view.backgroundColor = .background()
        topNaviView.setTopNavigation()
        backButton.tintColor = .themecolor()
        
        guidScrollView.frame.origin.y = topNaviView.frame.height
        guidScrollView.frame.size.height = self.view.frame.height - topNaviView.frame.height
        
        let guid_path1 = Bundle.main.path(forResource: "guid_screen1", ofType: "jpg")!
        let guid_path2 = Bundle.main.path(forResource: "guid_screen2", ofType: "jpg")!

        let guidimg1 = UIImage(contentsOfFile: guid_path1)!
        let guidimg2 = UIImage(contentsOfFile: guid_path2)!
        
        
        var height1 = (guidimg1.size.height * guidImgView1.frame.width)/guidimg1.size.width
        height1 = min(height1, 500)
        
        guidImgView1.frame.origin.y = titleLabel1.frame.origin.y + titleLabel1.frame.height + 15
        guidImgView1.frame.size.height = height1
        guidImgView1.image = guidimg1
        
        var ypoint = guidImgView1.frame.origin.y + guidImgView1.frame.height + 25
        titleLabel2.frame.origin.y = ypoint
        
        ypoint += titleLabel2.frame.height + 15
        var height2 = (guidimg2.size.height * guidImgView2.frame.width)/guidimg2.size.width
        height2 = min(height2, 500)
        
        //
        guidImgView2.frame.origin.y = ypoint
        guidImgView2.frame.size.height = height2
        guidImgView2.image = guidimg2

        //
        let scrollcontenHeight = ypoint + height2 + 60
        guidScrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollcontenHeight)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    @IBAction func btnBackPressed (_ sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

