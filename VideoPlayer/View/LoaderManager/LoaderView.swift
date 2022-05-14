//
//  LoaderView.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit


class LoaderView: UIView {
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var stringindicatorView: UIView!
    @IBOutlet weak var stringindicator: UIActivityIndicatorView!
    
    
    func load(inView:UIView, sms:String? = nil) {
        
        self.frame = inView.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        stringindicatorView.isHidden = true
        indicatorView.isHidden = true
        
        setIndicatorBackground(self.indicatorView)
        indicator.startAnimating()
        
        inView.addSubview(self)
    }
    
    
    
    func setIndicatorBackground(_ indiback:UIView)  {
        
        indiback.isHidden = false
        indiback.backgroundColor = UIColor.black.withAlphaComponent(0.90)
        indiback.layer.cornerRadius = 5
        indiback.layer.shadowOffset = CGSize(width: 0, height: 0)
        indiback.layer.shadowColor = UIColor.black.cgColor
        indiback.layer.shadowRadius = 5
        indiback.layer.shadowOpacity = 0.1
    }

    
    func unLoad() {
        self.indicator.stopAnimating()
        self.stringindicator.stopAnimating()
        self.removeFromSuperview()
    }
    
}
