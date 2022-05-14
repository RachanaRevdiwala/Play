//
//  BottomMenuCell.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

class BottomMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var menuLabel: UILabel!
    
    internal var menuitem:MenuItem? {
        didSet {
                
            imageButton.setImage(UIImage(named: menuitem!.imgName), for: .normal)
            imageButton.tintColor = .themecolor()
            imageButton.isEnabled = menuitem!.isEnable

            menuLabel.text = menuitem!.menuName
            menuLabel.textColor = .themecolor().withAlphaComponent(menuitem!.isEnable ? 1 : 0.3)
        }
    }
    
    
}
